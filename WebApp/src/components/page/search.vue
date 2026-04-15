<template>
    <div class="search-page">
        <app-head :searchInput="searchValue"></app-head>
        <app-body>
            <section class="search-hero">
                <div>
                    <div class="search-kicker">Search Feed</div>
                    <h1>{{ headline }}</h1>
                    <p>Fast, contrast-heavy browsing with cleaner cards and fewer distractions. Filter the feed, then jump straight to what matters.</p>
                </div>
                <div class="search-badge">{{ totalItem }} results</div>
            </section>

            <section class="results-shell">
                <div v-if="idleList.length === 0" class="empty-state">No matching items found.</div>
                        <el-row :gutter="24">
                            <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="idle in idleList" :key="idle.id">
                        <article class="idle-card" @click="toDetails(idle)">
                            <div class="idle-card-media">
                                <el-image style="width: 100%; height: 220px" :src="idle.imgUrl" fit="cover">
                                    <div slot="error" class="image-slot"><i class="el-icon-picture-outline">No Image</i></div>
                                </el-image>
                                <div class="idle-card-price">${{ idle.idlePrice }}</div>
                            </div>
                            <div class="idle-card-body">
                                <div class="idle-title">{{ idle.idleName }}</div>
                                <div class="idle-meta-row">
                                    <span class="idle-place">{{ idle.idlePlace }}</span>
                                    <span class="idle-time">{{ idle.timeStr }}</span>
                                </div>
                                <div class="user-info">
                                    <el-image style="width: 34px; height: 34px" :src="idle.user.avatar" fit="cover">
                                        <div slot="error" class="image-slot small"><i class="el-icon-picture-outline">No Image</i></div>
                                    </el-image>
                                    <div class="user-nickname">{{ idle.user.nickname }}</div>
                                </div>
                            </div>
                        </article>
                    </el-col>
                </el-row>
                <div class="fenye">
                    <el-pagination background @current-change="handleCurrentChange" :current-page.sync="currentPage" :page-size="8" layout="prev, pager, next, jumper" :total="totalItem"></el-pagination>
                </div>
            </section>
            <app-foot></app-foot>
        </app-body>
    </div>
</template>
<script>
import AppHead from '../common/AppHeader.vue';
import AppBody from '../common/AppPageBody.vue';
import AppFoot from '../common/AppFoot.vue';
import { mapIdlePreview } from '../../utils/idle';
export default {
    name: 'search',
    components: { AppHead, AppBody, AppFoot },
    data() { return { idleList: [], currentPage: 1, searchValue: '', totalItem: 0 }; },
    computed: {
        headline() {
            return this.searchValue ? `Results for "${this.searchValue}"` : 'Search all available listings';
        }
    },
    created() {
        const page = parseInt(this.$route.query.page, 10) || 1;
        this.currentPage = page;
        this.searchValue = this.$route.query.searchValue || '';
        this.findIdleItem(page, this.searchValue);
    },
    watch: {
        $route(to) {
            const page = parseInt(to.query.page, 10) || 1;
            this.currentPage = page;
            this.searchValue = to.query.searchValue || '';
            this.findIdleItem(page, this.searchValue);
        }
    },
    methods: {
        findIdleItem(page, findValue) {
            this.$api.findIdleTiem({ page, nums: 8, findValue }).then(res => {
                this.idleList = res.data.list.map(mapIdlePreview);
                this.totalItem = res.data.count;
            }).catch(() => {
                this.$message.error('Load failed, please retry.');
            });
        },
        handleCurrentChange(val) { this.$router.replace({ query: { page: val, searchValue: this.searchValue } }); },
        toDetails(idle) { this.$router.push({ path: '/details', query: { id: idle.id } }); }
    }
};
</script>
<style scoped>
.search-page { color: var(--text); }
.search-hero,
.results-shell {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}
.search-hero {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    padding: 30px 32px;
    margin-bottom: 24px;
}
.search-kicker {
    font-size: 12px;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--accent);
}
.search-hero h1 { margin: 14px 0 10px; font-size: 38px; }
.search-hero p { margin: 0; color: var(--text-soft); max-width: 780px; line-height: 1.7; }
.search-badge {
    padding: 16px 18px;
    border-radius: 18px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.08);
    font-weight: 800;
}
.results-shell { padding: 26px; }
.empty-state {
    padding: 30px 0 38px;
    text-align: center;
    color: var(--text-soft);
}
.idle-card {
    margin-bottom: 24px;
    border-radius: 22px;
    overflow: hidden;
    cursor: pointer;
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.06);
    transition: transform .28s ease, box-shadow .28s ease, border-color .28s ease;
}
.idle-card:hover { transform: translateY(-8px); border-color: rgba(124,255,107,0.32); box-shadow: 0 22px 44px rgba(0,0,0,.34); }
.idle-card-media { position: relative; }
.idle-card-price { position: absolute; left: 14px; bottom: 14px; padding: 8px 14px; border-radius: 999px; background: rgba(5,8,22,0.78); color: #fff; font-weight: 800; }
.idle-card-body { padding: 18px; }
.idle-title { font-size: 19px; font-weight: 800; min-height: 46px; }
.idle-meta-row { display: flex; justify-content: space-between; gap: 12px; margin-top: 14px; color: var(--text-soft); font-size: 13px; }
.user-info { display: flex; align-items: center; gap: 10px; margin-top: 18px; padding-top: 14px; border-top: 1px solid rgba(255,255,255,0.06); }
.user-nickname { font-size: 13px; color: rgba(255,255,255,0.78); }
.image-slot { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: rgba(255,255,255,0.03); color: rgba(255,255,255,0.45); }
.image-slot.small { font-size: 11px; }
.fenye { display: flex; justify-content: center; margin-top: 12px; }
@media (max-width: 720px) {
    .search-hero,
    .results-shell {
        padding: 22px;
    }

    .search-hero {
        flex-direction: column;
        align-items: flex-start;
    }

    .search-hero h1 {
        font-size: 32px;
    }

    .idle-title {
        min-height: 0;
    }

    .idle-meta-row {
        flex-direction: column;
        align-items: flex-start;
    }

    .fenye {
        justify-content: flex-start;
        overflow-x: auto;
        padding-bottom: 6px;
    }
}
</style>
