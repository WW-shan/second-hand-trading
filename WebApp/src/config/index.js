const DEFAULT_HOST = typeof window !== 'undefined' && window.location.hostname ? window.location.hostname : '127.0.0.1';
const DEFAULT_PROTOCOL = typeof window !== 'undefined' && window.location.protocol ? window.location.protocol : 'http:';
const BASE_API = process.env.VUE_APP_BASE_API || `${DEFAULT_PROTOCOL}//${DEFAULT_HOST}:8080`;
const NORMALIZED_BASE_API = BASE_API.replace(/\/$/, '');
const UPLOAD_URL = `${NORMALIZED_BASE_API}/file/`;
const AUTH_REQUIRED_PATHS = ['/me', '/message', '/release', '/order'];
const REQUEST_TIMEOUT = Number(process.env.VUE_APP_REQUEST_TIMEOUT || 8000);
const APP_TITLE = 'AIEN Second-hand Trading Platform';

export {
    APP_TITLE,
    BASE_API,
    REQUEST_TIMEOUT,
    UPLOAD_URL,
    AUTH_REQUIRED_PATHS
};
