<template>
    <div class="auth-page">
        <div class="auth-shell">
            <section class="auth-brand-panel signup-panel">
                <div class="auth-kicker">SELL / COLLECT / MOVE FAST</div>
                <h1>Join the market. <span>Turn idle inventory into high-intent listings with a cleaner visual identity.</span></h1>
                <p>AIEN is built for people who want product-first resale with less friction and more confidence in every interaction.</p>
            </section>
            <section class="auth-form-panel">
                <div class="sign-in-title">Create Your Account</div>
                <el-input placeholder="Enter nickname..." maxlength="30" v-model="userInfo.nickname" class="sign-in-input" clearable>
                    <template slot="prepend"><div class="el-icon-user-solid"></div></template>
                </el-input>
                <el-input placeholder="Enter phone number..." maxlength="11" v-model="userInfo.accountNumber" class="sign-in-input" clearable>
                    <template slot="prepend"><div class="el-icon-phone"></div></template>
                </el-input>
                <el-input placeholder="Enter password..." show-password maxlength="16" v-model="userInfo.userPassword" class="sign-in-input" clearable>
                    <template slot="prepend"><div class="el-icon-lock"></div></template>
                </el-input>
                <el-input placeholder="Re-enter password..." show-password maxlength="16" v-model="userPassword2" @keyup.enter.native="signIn" class="sign-in-input" clearable>
                    <template slot="prepend"><div class="el-icon-lock"></div></template>
                </el-input>
                <div class="sign-in-submit"><el-button type="primary" @click="signIn">Create Account</el-button></div>
                <div class="login-container"><span @click="toLogin" class="login-text">Back to Sign In</span></div>
            </section>
        </div>
    </div>
</template>
<script>
export default {
    name: 'sign-in',
    data() {
        return { userPassword2: '', userInfo: { accountNumber: '', userPassword: '', nickname: '' } };
    },
    methods: {
        toLogin() { this.$router.replace({ path: '/login' }); },
        signIn() {
            if (this.userInfo.accountNumber && this.userInfo.userPassword && this.userInfo.nickname) {
                if (this.userInfo.userPassword !== this.userPassword2) {
                    this.$message.error('The two passwords do not match.');
                } else {
                    this.$api.signIn(this.userInfo).then(res => {
                        if (res.status_code === 1) {
                            this.$message({ message: 'Sign-up successful!', type: 'success' });
                            this.$router.replace({ path: '/login' });
                        } else {
                            this.$message.error('Sign-up failed. User already exists.');
                        }
                    }).catch(() => {
                        this.$message.error('Sign-up failed due to a network error.');
                    });
                }
            } else {
                this.$message.error('Please complete the sign-up form.');
            }
        }
    }
};
</script>
<style scoped>
.auth-page { min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 32px 18px; }
.auth-shell { width: min(1120px, 100%); display: grid; grid-template-columns: 1.15fr 0.85fr; gap: 24px; }
.auth-brand-panel,.auth-form-panel { border-radius: var(--radius-xl); background: var(--panel); border: 1px solid var(--panel-border); box-shadow: var(--shadow); }
.auth-brand-panel { padding: 42px; background: radial-gradient(circle at top left, rgba(124,255,107,0.18), transparent 24%), radial-gradient(circle at bottom right, rgba(0,221,255,0.18), transparent 28%), var(--panel-strong); }
.auth-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent-2); }
.auth-brand-panel h1 { margin: 18px 0; font-size: 50px; line-height: .96; letter-spacing: -0.04em; }
.auth-brand-panel h1 span { display: block; color: rgba(255,255,255,0.72); }
.auth-brand-panel p { color: var(--text-soft); line-height: 1.8; max-width: 560px; }
.auth-form-panel { padding: 34px; display: flex; flex-direction: column; justify-content: center; }
.sign-in-title { padding-bottom: 28px; text-align: left; font-weight: 800; font-size: 28px; line-height: 1.1; color: #fff; }
.sign-in-input { margin-bottom: 18px; }
.sign-in-submit { display: flex; justify-content: flex-start; margin-top: 8px; }
.login-container { padding-top: 18px; }
.login-text { color: var(--text-soft); font-size: 14px; cursor: pointer; }
@media (max-width: 980px) { .auth-shell { grid-template-columns: 1fr; } .auth-brand-panel h1 { font-size: 40px; } }
</style>
