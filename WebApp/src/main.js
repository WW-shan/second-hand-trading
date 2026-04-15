import Vue from 'vue';
import App from './App.vue';
import router from './router';
import ElementLocale from 'element-ui/lib/locale';
import locale from 'element-ui/lib/locale/lang/en';
import {
    Avatar,
    Button,
    Cascader,
    Checkbox,
    Col,
    Dialog,
    Dropdown,
    DropdownItem,
    DropdownMenu,
    Form,
    Image,
    Input,
    InputNumber,
    Loading,
    Menu,
    MenuItem,
    Option,
    PageHeader,
    Pagination,
    Row,
    Select,
    Table,
    TableColumn,
    TabPane,
    Tabs,
    Upload,
    Message,
    MessageBox
} from 'element-ui';

import api from './api/index.js';
import { APP_TITLE, AUTH_REQUIRED_PATHS } from './config';
Vue.prototype.$api = api;

const defaultUserInfo = () => ({
    nickname: '',
    avatar: '',
    signInTime: ''
});

let globalData = {
    userInfo: defaultUserInfo()
};
let sta = {
    isLogin: false,
    adminName: ''
};
let userSessionRequest = null;

function normalizeUserInfo(userInfo = {}) {
    return {
        ...defaultUserInfo(),
        ...userInfo,
        signInTime: userInfo.signInTime ? userInfo.signInTime.substring(0, 10) : ''
    };
}

function setUserSession(userInfo) {
    const normalizedUserInfo = normalizeUserInfo(userInfo);
    globalData.userInfo = normalizedUserInfo;
    return normalizedUserInfo;
}

function clearUserSession() {
    globalData.userInfo = defaultUserInfo();
    userSessionRequest = null;
}

function ensureUserSession() {
    if (globalData.userInfo.nickname) {
        return Promise.resolve(globalData.userInfo);
    }

    if (userSessionRequest) {
        return userSessionRequest;
    }

    userSessionRequest = api.getUserInfo().then(res => {
        if (res.status_code !== 1 || !res.data) {
            throw new Error('Unauthenticated');
        }
        return setUserSession(res.data);
    }).finally(() => {
        userSessionRequest = null;
    });

    return userSessionRequest;
}

Vue.prototype.$sta = sta;
Vue.prototype.$globalData = globalData;
Vue.prototype.$setUserSession = setUserSession;
Vue.prototype.$clearUserSession = clearUserSession;
Vue.prototype.$ensureUserSession = ensureUserSession;

Vue.config.productionTip = false;

ElementLocale.use(locale);
Vue.prototype.$ELEMENT = { size: 'medium' };

[
    Avatar,
    Button,
    Cascader,
    Checkbox,
    Col,
    Dialog,
    Dropdown,
    DropdownItem,
    DropdownMenu,
    Form,
    Image,
    Input,
    InputNumber,
    Menu,
    MenuItem,
    Option,
    PageHeader,
    Pagination,
    Row,
    Select,
    Table,
    TableColumn,
    TabPane,
    Tabs,
    Upload
].forEach(component => {
    Vue.use(component);
});

Vue.prototype.$loading = Loading.service;
Vue.prototype.$message = Message;
Vue.prototype.$msgbox = MessageBox;
Vue.prototype.$alert = MessageBox.alert;
Vue.prototype.$confirm = MessageBox.confirm;
Vue.prototype.$prompt = MessageBox.prompt;


router.beforeEach((to, from, next) => {
    document.title = to.meta.title || APP_TITLE;
    const nickname = Vue.prototype.$globalData.userInfo.nickname;
    if (!AUTH_REQUIRED_PATHS.includes(to.path) || nickname) {
        next();
        return;
    }

    ensureUserSession().then(() => {
        next();
    }).catch(() => {
        clearUserSession();
        if (to.path !== '/login') {
            next('/login');
            return;
        }
        next();
    });
});

new Vue({
    router,
    render: h => h(App)
}).$mount('#app');
