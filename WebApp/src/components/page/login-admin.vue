<template>
    <div class="auth-page">
        <div class="auth-shell">
            <section class="auth-brand-panel admin-brand-panel">
                <div class="auth-kicker">AIEN / ADMIN MODE</div>
                <h1>Moderate fast. <span>Keep the marketplace clean, visible, and under control.</span></h1>
                <p>Review user activity, listings, and orders from a console that matches the upgraded storefront language.</p>
            </section>
            <section class="auth-form-panel">
                <div class="login-title">Admin Console Sign In</div>
                <el-form ref="form" :model="userForm">
                    <el-input placeholder="Enter admin account" v-model="userForm.accountNumber" class="login-input">
                        <template slot="prepend"><div class="el-icon-user-solid"></div></template>
                    </el-input>
                    <el-input placeholder="Enter admin password" v-model="userForm.adminPassword" class="login-input" @keyup.enter.native="login" show-password>
                        <template slot="prepend"><div class="el-icon-lock"></div></template>
                    </el-input>
                    <div class="login-submit"><el-button type="primary" @click="login">Sign In</el-button></div>
                    <div class="other-submit"><router-link to="/login" class="sign-in-text">Back to Store</router-link></div>
                </el-form>
            </section>
        </div>
    </div>
</template>
<script>
export default {
    name: 'login-admin',
    data() {
        return { userForm: { accountNumber: 'root', adminPassword: '123456' } };
    },
    methods: {
        login() {
            this.$api.adminLogin(this.userForm).then(res => {
                if (res.status_code === 1) {
                    this.$sta.isLogin = true;
                    this.$sta.adminName = res.data.adminName;
                    this.$router.replace({ path: '/platform-admin' });
                } else {
                    this.$message.error('Sign-in failed. Incorrect account or password.');
                }
            }).catch(() => {
                this.$message.error('Sign-in failed due to a network error.');
            });
        }
    }
};
</script>
<style scoped>
.auth-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 32px 18px; }
.auth-shell { width: min(1120px, 100%); display: grid; grid-template-columns: 1.15fr 0.85fr; gap: 24px; }
.auth-brand-panel,
.auth-form-panel { border-radius: var(--radius-xl); background: var(--panel); border: 1px solid var(--panel-border); box-shadow: var(--shadow); }
.admin-brand-panel {
    padding: 42px;
    background: radial-gradient(circle at top left, rgba(255,93,143,0.14), transparent 26%), radial-gradient(circle at bottom right, rgba(0,221,255,0.16), transparent 30%), var(--panel-strong);
}
.auth-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.auth-brand-panel h1 { margin: 18px 0; font-size: 50px; line-height: .96; letter-spacing: -0.04em; }
.auth-brand-panel h1 span { display: block; color: rgba(255,255,255,0.72); }
.auth-brand-panel p { color: var(--text-soft); line-height: 1.8; max-width: 560px; }
.auth-form-panel { padding: 34px; display: flex; flex-direction: column; justify-content: center; }
.login-title { padding-bottom: 28px; text-align: left; font-weight: 800; font-size: 28px; line-height: 1.1; color: #fff; }
.login-input { margin-bottom: 18px; }
.login-submit { display: flex; justify-content: flex-start; margin-top: 8px; }
.other-submit { display: flex; justify-content: flex-start; margin-top: 18px; }
.sign-in-text { color: var(--text-soft); font-size: 14px; text-decoration: none; }
@media (max-width: 980px) { .auth-shell { grid-template-columns: 1fr; } .auth-brand-panel h1 { font-size: 40px; } }
</style>
