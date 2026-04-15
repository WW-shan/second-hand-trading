import axios from 'axios';
import { BASE_API, REQUEST_TIMEOUT } from '../config';

const pendingGetRequests = new Map();

const service = axios.create({
    timeout: REQUEST_TIMEOUT,
    baseURL: BASE_API,
    withCredentials: true
});

function sortPlainObject(value) {
    if (Array.isArray(value)) {
        return value.map(sortPlainObject);
    }

    if (value && Object.prototype.toString.call(value) === '[object Object]') {
        return Object.keys(value).sort().reduce((result, key) => {
            result[key] = sortPlainObject(value[key]);
            return result;
        }, {});
    }

    return value;
}

function buildRequestKey(config) {
    return JSON.stringify({
        method: config.method,
        url: config.url,
        params: sortPlainObject(config.params || {})
    });
}

function normalizeRequestError(error) {
    if (error && error.userMessage) {
        return error;
    }

    let userMessage = 'Request failed. Please try again.';
    const normalizedError = new Error(userMessage);
    normalizedError.originalError = error;

    if (error && error.code === 'ECONNABORTED') {
        userMessage = `Request timed out after ${REQUEST_TIMEOUT} ms.`;
    } else if (error && error.response) {
        normalizedError.status = error.response.status;
        userMessage = {
            400: 'Bad request. Please verify your input and retry.',
            401: 'Your session is no longer valid. Please sign in again.',
            403: 'You do not have permission to perform this action.',
            404: 'Requested resource was not found.',
            500: 'Server error. Please retry in a moment.',
            502: 'Gateway error. Please retry in a moment.',
            503: 'Service temporarily unavailable. Please retry shortly.'
        }[error.response.status] || `Request failed with status ${error.response.status}.`;
    } else if (error && error.request) {
        userMessage = 'Unable to reach the server. Please check that the backend is running.';
    }

    normalizedError.message = userMessage;
    normalizedError.userMessage = userMessage;
    return normalizedError;
}

service.interceptors.request.use(
    config => {
        return config;
    },
    error => {
        return Promise.reject(error);
    }
);

service.interceptors.response.use(
    response => {
        if (response.status === 200) {
            return response.data;
        }
        return Promise.reject(new Error(`Unexpected response status: ${response.status}`));
    },
    error => {
        return Promise.reject(error);
    }
);

function request(config) {
    const normalizedConfig = {
        dedupe: true,
        ...config,
        method: (config.method || 'get').toLowerCase()
    };

    const isDedupeGetRequest = normalizedConfig.method === 'get' && normalizedConfig.dedupe !== false;
    if (!isDedupeGetRequest) {
        return service(normalizedConfig).catch(error => Promise.reject(normalizeRequestError(error)));
    }

    const requestKey = buildRequestKey(normalizedConfig);
    if (pendingGetRequests.has(requestKey)) {
        return pendingGetRequests.get(requestKey);
    }

    const requestPromise = service(normalizedConfig)
        .catch(error => Promise.reject(normalizeRequestError(error)))
        .finally(() => {
            pendingGetRequests.delete(requestKey);
        });

    pendingGetRequests.set(requestKey, requestPromise);
    return requestPromise;
}

export default request;
