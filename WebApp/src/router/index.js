import Vue from 'vue';
import Router from 'vue-router';

const originalReplace = Router.prototype.replace;
Router.prototype.replace = function replace(location) {
    return originalReplace.call(this, location).catch(err => err);
};
const originalPush = Router.prototype.push;
Router.prototype.push = function push(location) {
    return originalPush.call(this, location).catch(err => err);
};

Vue.use(Router);

const IndexPage = () => import(/* webpackChunkName: "page-market-index" */ '../components/page/index.vue');
const SearchPage = () => import(/* webpackChunkName: "page-market-search" */ '../components/page/search.vue');
const ProfilePage = () => import(/* webpackChunkName: "page-market-profile" */ '../components/page/me.vue');
const MessagePage = () => import(/* webpackChunkName: "page-market-message" */ '../components/page/message.vue');
const ReleasePage = () => import(/* webpackChunkName: "page-market-release" */ '../components/page/release.vue');
const DetailsPage = () => import(/* webpackChunkName: "page-market-details" */ '../components/page/idle-details.vue');
const OrderPage = () => import(/* webpackChunkName: "page-market-order" */ '../components/page/order.vue');
const LoginPage = () => import(/* webpackChunkName: "page-auth-login" */ '../components/page/login.vue');
const SignInPage = () => import(/* webpackChunkName: "page-auth-register" */ '../components/page/sign-in.vue');
const AdminLoginPage = () => import(/* webpackChunkName: "page-admin-login" */ '../components/page/login-admin.vue');
const AdminConsolePage = () => import(/* webpackChunkName: "page-admin-console" */ '../components/page/platform-admin.vue');

export default new Router({
    routes: [
        { path: '/', redirect: '/index' },
        { path: '/index', component: IndexPage, meta: { title: 'AIEN Second-hand Trading Platform' } },
        { path: '/search', component: SearchPage, meta: { title: 'Search | AIEN Second-hand Trading Platform' } },
        { path: '/me', component: ProfilePage, meta: { title: 'Profile | AIEN Second-hand Trading Platform' } },
        { path: '/message', component: MessagePage, meta: { title: 'Messages | AIEN Second-hand Trading Platform' } },
        { path: '/release', component: ReleasePage, meta: { title: 'Sell Item | AIEN Second-hand Trading Platform' } },
        { path: '/details', component: DetailsPage, meta: { title: 'Item Details | AIEN Second-hand Trading Platform' } },
        { path: '/order', component: OrderPage, meta: { title: 'Order Details | AIEN Second-hand Trading Platform' } },
        { path: '/login', component: LoginPage, meta: { title: 'Sign In | AIEN Second-hand Trading Platform' } },
        { path: '/sign-in', component: SignInPage, meta: { title: 'Sign Up | AIEN Second-hand Trading Platform' } },
        { path: '/login-admin', component: AdminLoginPage, meta: { title: 'Admin Sign In | AIEN Second-hand Trading Platform' } },
        { path: '/platform-admin', component: AdminConsolePage, meta: { title: 'Admin Console | AIEN Second-hand Trading Platform' } },
        { path: '*', redirect: '/' }
    ]
});
