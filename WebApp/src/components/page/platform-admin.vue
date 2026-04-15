<template>
    <div class="admin-page">
        <div class="admin-shell">
            <aside class="admin-sidebar">
                <router-link to="/platform-admin" class="admin-brand">
                    <span>AIEN / ADMIN</span>
                    <strong>Marketplace Console</strong>
                </router-link>
                <div class="admin-user-block">
                    <span class="admin-user-caption">Signed in as</span>
                    <strong>{{ admin.nickname }}</strong>
                </div>
                <el-menu default-active="1" class="admin-menu" @select="handleSelect" background-color="transparent" text-color="#98a3c7" active-text-color="#ffffff">
                    <el-menu-item index="1"><i class="el-icon-goods"></i><span>Item Management</span></el-menu-item>
                    <el-menu-item index="2"><i class="el-icon-s-goods"></i><span slot="title">Order Management</span></el-menu-item>
                    <el-menu-item index="3"><i class="el-icon-s-custom"></i><span slot="title">User Management</span></el-menu-item>
                </el-menu>
                <el-button class="admin-logout" type="danger" plain @click="logout">Sign Out</el-button>
            </aside>
            <section class="admin-main">
                <div class="admin-main-header">
                    <div>
                        <div class="page-kicker">Admin Console</div>
                        <h1>{{ mode === 1 ? 'Item Management' : mode === 2 ? 'Order Management' : 'User Management' }}</h1>
                    </div>
                    <div class="admin-main-note">AIEN - real-time moderation and marketplace oversight</div>
                </div>
                <div class="admin-main-panel">
                    <IdleGoods v-if="mode == 1"></IdleGoods>
                    <orderList v-if="mode == 2"></orderList>
                    <userList v-if="mode == 3"></userList>
                </div>
                <app-foot></app-foot>
            </section>
        </div>
    </div>
</template>
<script>
import AppFoot from '../common/AppFoot.vue';
import IdleGoods from '../common/IdleGoods.vue';
import orderList from '../common/orderList.vue';
import userList from '../common/userList.vue';
export default {
    name: 'platform-admin',
    components: { AppFoot, IdleGoods, orderList, userList },
    data() { return { mode: 1, admin: { nickname: 'Administrator' } }; },
    created() { this.admin.nickname = this.$sta.adminName; },
    methods: {
        logout() {
            this.$api.loginOut({}).then(res => {
                if (res.status_code === 1) {
                    this.$sta.isLogin = false;
                    this.$sta.adminName = '';
                    this.$router.push({ path: '/login-admin' });
                }
            }).catch(console.log);
        },
        handleSelect(val) {
            const nextMode = Number(val);
            if (this.mode !== nextMode) this.mode = nextMode;
        }
    }
}
</script>
<style scoped>
.admin-page { padding: 24px 18px 40px; }
.admin-shell { width: min(1400px, 100%); margin: 0 auto; display: grid; grid-template-columns: 280px 1fr; gap: 24px; }
.admin-sidebar,
.admin-main-header,
.admin-main-panel {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}
.admin-sidebar { padding: 24px; display: flex; flex-direction: column; min-height: calc(100vh - 48px); }
.admin-brand { text-decoration: none; color: #fff; display: flex; flex-direction: column; }
.admin-brand span { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.admin-brand strong { margin-top: 8px; font-size: 28px; line-height: 1.05; }
.admin-user-block { margin: 28px 0 18px; padding: 16px 18px; border-radius: 18px; background: rgba(255,255,255,0.04); }
.admin-user-caption { display: block; font-size: 11px; letter-spacing: 0.12em; text-transform: uppercase; color: rgba(255,255,255,0.5); margin-bottom: 8px; }
.admin-menu { border: none !important; background: transparent !important; }
.admin-logout { margin-top: auto; }
.admin-main { min-width: 0; }
.admin-main-header { display: flex; justify-content: space-between; align-items: flex-end; gap: 20px; padding: 28px 30px; margin-bottom: 24px; }
.admin-main-header h1 { margin: 12px 0 0; font-size: 36px; }
.admin-main-note { color: var(--text-soft); max-width: 260px; text-align: right; }
.admin-main-panel { padding: 24px; }
@media (max-width: 1100px) { .admin-shell { grid-template-columns: 1fr; } .admin-sidebar { min-height: auto; } .admin-main-header { flex-direction: column; align-items: flex-start; } }
</style>
