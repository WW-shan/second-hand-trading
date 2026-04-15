<template>
    <div class="auth-page">
        <div class="auth-shell">
            <section class="auth-brand-panel">
                <div class="auth-kicker">AIEN MARKET</div>
                <h1>Buy rare. Flip fast. <span>Second-hand trading, reimagined for a sharper generation.</span></h1>
                <p>Every screen now feels like a premium resale product - cleaner search, stronger hierarchy, and faster decision making.</p>
                <div class="auth-points">
                    <div>Fast sign-in for returning users</div>
                    <div>Visual-first product browsing</div>
                    <div>Low-friction selling workflow</div>
                </div>
            </section>
            <section class="auth-form-panel">
                <div class="login-title" @click="toIndex">AIEN Second-hand Trading Platform</div>
                <el-form ref="form" :model="userForm">
                    <el-input placeholder="Enter phone number..." v-model="userForm.accountNumber" class="login-input">
                        <template slot="prepend"><div class="el-icon-user-solid"></div></template>
                    </el-input>
                    <el-input placeholder="Enter password..." v-model="userForm.userPassword" class="login-input" @keyup.enter.native="login" show-password>
                        <template slot="prepend"><div class="el-icon-lock"></div></template>
                    </el-input>
                    <div class="login-submit"><el-button type="primary" @click="login">Sign In</el-button></div>
                    <div class="other-submit">
                        <router-link to="/sign-in" class="sign-in-text">Sign Up</router-link>
                        <router-link to="/login-admin" class="sign-in-text">Admin Sign In</router-link>
                    </div>
                </el-form>
            </section>
        </div>
    </div>
</template>
<script>
export default {
    name: 'login',
    data() {
        return { userForm: { accountNumber: '17322611234', userPassword: '123456' } };
    },
    methods: {
        login() {
            this.$api.userLogin(this.userForm).then(res => {
                if (res.status_code === 1) {
                    this.$setUserSession(res.data);
                    this.$router.replace({ path: '/index' });
                } else {
                    this.$message.error('Sign-in failed. Please check your account or password.');
                }
            }).catch(error => {
                this.$message.error(error.userMessage || 'Sign-in failed due to a network error.');
            });
        },
        toIndex() { this.$router.replace({ path: '/index' }); }
    }
};
</script>
<style scoped>
.auth-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 32px 18px; }
.auth-shell {
    width: min(1120px, 100%);
    display: grid;
    grid-template-columns: 1.15fr 0.85fr;
    gap: 24px;
}
.auth-brand-panel,
.auth-form-panel {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}
.auth-brand-panel {
    padding: 42px;
    background:
        radial-gradient(circle at top right, rgba(0,221,255,0.16), transparent 28%),
        radial-gradient(circle at bottom left, rgba(124,255,107,0.16), transparent 24%),
        var(--panel-strong);
}
.auth-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.auth-brand-panel h1 { margin: 18px 0; font-size: 54px; line-height: .95; letter-spacing: -0.04em; }
.auth-brand-panel h1 span { display: block; color: rgba(255,255,255,0.72); }
.auth-brand-panel p { color: var(--text-soft); line-height: 1.8; max-width: 560px; }
.auth-points { margin-top: 28px; display: grid; gap: 12px; }
.auth-points div { padding: 14px 16px; border-radius: 16px; background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.84); }
.auth-form-panel { padding: 34px; display: flex; flex-direction: column; justify-content: center; }
.login-title { padding-bottom: 28px; text-align: left; font-weight: 800; font-size: 28px; line-height: 1.1; color: #fff; cursor: pointer; }
.login-input { margin-bottom: 18px; }
.login-submit { display: flex; justify-content: flex-start; margin-top: 8px; }
.other-submit { display: flex; justify-content: space-between; padding-top: 18px; }
.sign-in-text { color: var(--text-soft); font-size: 14px; cursor: pointer; text-decoration: none; }
@media (max-width: 980px) { .auth-shell { grid-template-columns: 1fr; } .auth-brand-panel h1 { font-size: 42px; } }
</style>
