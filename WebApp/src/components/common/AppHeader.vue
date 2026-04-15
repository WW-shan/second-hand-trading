<template>
    <div class="header">
        <div class="header-container">
            <router-link to="/" class="app-name">
                <span class="brand-kicker">AIEN</span>
                <span class="brand-title">Second-hand Trading Platform</span>
            </router-link>

            <div class="search-container">
                <el-input placeholder="Search items, creators, categories..." v-model="searchValue" @keyup.enter.native="searchIdle">
                    <el-button slot="append" icon="el-icon-search" @click="searchIdle"></el-button>
                </el-input>
            </div>

            <div class="header-actions">
                <el-button class="ghost-action" icon="el-icon-plus" @click="toRelease">Sell</el-button>
                <el-button class="ghost-action" icon="el-icon-chat-dot-round" @click="toMessage">Inbox</el-button>
                <router-link v-if="!isLogin" class="user-name-text" to="/login">Sign In</router-link>
                <el-dropdown v-else trigger="click">
                    <div class="user-trigger">
                        <div class="user-copy">
                            <span class="user-caption">Account</span>
                            <span class="user-name">{{ nicknameValue ? nicknameValue : nickname }}</span>
                        </div>
                        <el-avatar :src="avatarValue ? avatarValue : avatar"></el-avatar>
                    </div>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item><div @click="toMe">Profile</div></el-dropdown-item>
                        <el-dropdown-item divided><div @click="loginOut">Sign Out</div></el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </div>
        </div>
    </div>
</template>
<script>
export default {
    name: 'Header',
    props: ['searchInput', 'nicknameValue', 'avatarValue'],
    data() {
        return {
            searchValue: this.searchInput,
            nickname: 'Sign In',
            avatar: 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png',
            isLogin: false
        };
    },
    watch: {
        searchInput(val) {
            this.searchValue = val;
        }
    },
    created() {
        if (this.$globalData.userInfo.nickname) {
            this.syncHeaderUser(this.$globalData.userInfo);
            return;
        }

        this.$ensureUserSession().then(userInfo => {
            this.syncHeaderUser(userInfo);
        }).catch(() => {});
    },
    methods: {
        syncHeaderUser(userInfo) {
            this.nickname = userInfo.nickname;
            this.avatar = userInfo.avatar;
            this.isLogin = true;
        },
        searchIdle() {
            if ('/search' !== this.$route.path) {
                this.$router.push({ path: '/search', query: { searchValue: this.searchValue } });
            } else {
                this.$router.replace({ path: '/search', query: { searchValue: this.searchValue } });
                this.$router.go(0);
            }
        },
        toMe() {
            if ('/me' !== this.$route.path) this.$router.push({ path: '/me' });
        },
        toMessage() {
            if ('/message' !== this.$route.path) this.$router.push({ path: '/message' });
        },
        toRelease() {
            if ('/release' !== this.$route.path) this.$router.push({ path: '/release' });
        },
        loginOut() {
            this.$api.logout().then(res => {
                if (res.status_code === 1) {
                    this.$clearUserSession();
                    this.isLogin = false;
                    if ('/index' === this.$route.path) this.$router.go(0);
                    else this.$router.push({ path: '/index' });
                } else {
                    this.$message.error('Sign-out failed due to a network or system error.');
                }
            });
        }
    }
};
</script>
<style scoped>
.header {
    position: fixed;
    inset: 0 0 auto 0;
    z-index: 1000;
    padding: 16px 18px 0;
}

.header-container {
    width: min(var(--content-width), calc(100vw - 36px));
    min-height: 76px;
    margin: 0 auto;
    padding: 0 22px;
    display: grid;
    grid-template-columns: 290px minmax(320px, 1fr) auto;
    align-items: center;
    gap: 18px;
    border-radius: 24px;
    background: rgba(8, 12, 26, 0.78);
    border: 1px solid rgba(255, 255, 255, 0.07);
    box-shadow: var(--shadow);
    backdrop-filter: blur(18px);
}

.app-name {
    display: flex;
    flex-direction: column;
    text-decoration: none;
    color: #fff;
}

.brand-kicker {
    font-family: 'Rajdhani', sans-serif;
    font-size: 26px;
    line-height: 1;
    letter-spacing: 0.22em;
    color: var(--accent);
    text-transform: uppercase;
}

.brand-title {
    margin-top: 6px;
    font-size: 12px;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.6);
}

.search-container {
    position: relative;
    min-width: 0;
}

.header-actions {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
    justify-content: flex-end;
}

.ghost-action,
.user-name-text {
    min-width: 108px;
    padding: 11px 18px;
    border-radius: 14px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.08);
    color: #fff;
    text-decoration: none;
    text-align: center;
}

.header-actions :deep(.el-dropdown) {
    display: flex;
}

.user-trigger {
    display: flex;
    align-items: center;
    gap: 12px;
    cursor: pointer;
}

.user-copy {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
}

.user-caption {
    font-size: 10px;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.48);
}

.user-name {
    color: #fff;
    font-weight: 700;
}

@media (max-width: 1120px) {
    .header-container {
        height: auto;
        padding: 16px 18px;
        grid-template-columns: minmax(0, 1fr) auto;
        row-gap: 14px;
    }

    .search-container {
        grid-column: 1 / -1;
    }
}

@media (max-width: 720px) {
    .header {
        padding: 12px 12px 0;
    }

    .header-container {
        width: calc(100vw - 24px);
        grid-template-columns: 1fr;
        gap: 14px;
        padding: 16px;
        border-radius: 22px;
    }

    .brand-kicker {
        font-size: 22px;
    }

    .brand-title {
        font-size: 11px;
    }

    .header-actions {
        width: 100%;
        justify-content: stretch;
        gap: 10px;
    }

    .ghost-action,
    .user-name-text,
    .header-actions :deep(.el-dropdown) {
        flex: 1 1 calc(50% - 10px);
        min-width: 0;
    }

    .user-trigger {
        width: 100%;
        padding: 11px 14px;
        justify-content: space-between;
        border-radius: 14px;
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.08);
    }

    .user-copy {
        align-items: flex-start;
    }
}
</style>
