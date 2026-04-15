<template>
    <div class="market-page">
        <app-head></app-head>
        <app-body>
            <section class="market-hero">
                <div class="hero-copy">
                    <div class="hero-kicker">AIEN / NEXT-GEN MARKET</div>
                    <h1>Trade harder. Discover sharper. <span>Own standout second-hand pieces with confidence.</span></h1>
                    <p>Built for a fast-moving community that values rarity, speed, and cleaner product storytelling than the usual resale clutter.</p>
                    <div class="hero-actions">
                        <el-button type="primary" @click="scrollToCatalog">Explore Drops</el-button>
                        <el-button plain @click="$router.push({ path: '/release' })">List an Item</el-button>
                    </div>
                    <div class="hero-stats">
                        <div class="hero-stat">
                            <span class="hero-stat-label">Live Listings</span>
                            <strong>{{ totalItem }}</strong>
                        </div>
                        <div class="hero-stat">
                            <span class="hero-stat-label">Category</span>
                            <strong>{{ activeCategoryLabel }}</strong>
                        </div>
                        <div class="hero-stat">
                            <span class="hero-stat-label">Feed Style</span>
                            <strong>Curated + Fast</strong>
                        </div>
                    </div>
                </div>
                <div class="hero-panel">
                    <div class="hero-panel-label">Trending Marketplace</div>
                    <div class="hero-panel-title">Dark-mode commerce built for the scroll generation.</div>
                    <div class="hero-panel-line"></div>
                    <p>High contrast. Clear pricing. Visual-first cards. Less friction between discovery and checkout.</p>
                </div>
            </section>

            <section id="catalog" class="catalog-shell">
                <div class="catalog-toolbar">
                    <div>
                        <div class="section-kicker">Fresh Inventory</div>
                        <h2>Curated Drops</h2>
                    </div>
                    <div class="catalog-meta">{{ totalItem }} items live now</div>
                </div>

                <el-tabs v-model="labelName" type="card" class="market-tabs" @tab-click="handleClick">
                    <el-tab-pane label="All" name="0"></el-tab-pane>
                    <el-tab-pane label="Digital" name="1"></el-tab-pane>
                    <el-tab-pane label="Appliances" name="2"></el-tab-pane>
                    <el-tab-pane label="Outdoor" name="3"></el-tab-pane>
                    <el-tab-pane label="Books" name="4"></el-tab-pane>
                    <el-tab-pane label="Other" name="5"></el-tab-pane>
                </el-tabs>

                <div class="catalog-grid">
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
                </div>

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
    name: 'index',
    components: { AppHead, AppBody, AppFoot },
    data() { return { labelName: '0', idleList: [], currentPage: 1, totalItem: 1 }; },
    computed: {
        activeCategoryLabel() {
            return { '0': 'All', '1': 'Digital', '2': 'Appliances', '3': 'Outdoor', '4': 'Books', '5': 'Other' }[this.labelName] || 'All';
        }
    },
    created() { this.findIdleItem(1); },
    watch: {
        $route(to) {
            this.labelName = to.query.labelName || '0';
            const page = parseInt(to.query.page, 10) || 1;
            this.currentPage = page;
            this.findIdleItem(page);
        }
    },
    methods: {
        findIdleItem(page) {
            const loading = this.$loading({ lock: true, text: 'Loading...', spinner: 'el-icon-loading', background: 'rgba(0, 0, 0, 0)' });
            const request = this.labelName > 0
                ? this.$api.findIdleTiemByLable({ idleLabel: this.labelName, page, nums: 8 })
                : this.$api.findIdleTiem({ page, nums: 8 });
            request.then(res => {
                this.idleList = res.data.list.map(mapIdlePreview);
                this.totalItem = res.data.count;
            }).catch(() => {
                this.$message.error('Load failed, please retry.');
            }).finally(() => loading.close());
        },
        handleClick() { this.$router.replace({ query: { page: 1, labelName: this.labelName } }); },
        handleCurrentChange(val) { this.$router.replace({ query: { page: val, labelName: this.labelName } }); },
        toDetails(idle) { this.$router.push({ path: '/details', query: { id: idle.id } }); },
        scrollToCatalog() {
            const target = document.getElementById('catalog');
            if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }
};
</script>
<style scoped>
.market-page { color: var(--text); }
.market-hero {
    display: grid;
    grid-template-columns: 1.35fr 0.95fr;
    gap: 24px;
    padding: 8px 0 28px;
}
.hero-copy,
.hero-panel,
.catalog-shell {
    position: relative;
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
    overflow: hidden;
}
.hero-copy {
    padding: 42px;
}
.hero-copy::after,
.hero-panel::after,
.catalog-shell::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, rgba(255,255,255,0.04), transparent 30%);
    pointer-events: none;
}
.hero-kicker,
.section-kicker,
.hero-panel-label {
    font-size: 12px;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--accent);
}
.hero-copy h1 {
    margin: 18px 0 16px;
    font-size: 54px;
    line-height: 0.95;
    letter-spacing: -0.04em;
}
.hero-copy h1 span {
    display: block;
    color: rgba(255,255,255,0.72);
}
.hero-copy p,
.hero-panel p,
.catalog-meta {
    color: var(--text-soft);
    line-height: 1.8;
}
.hero-actions {
    display: flex;
    gap: 14px;
    margin: 28px 0 34px;
}
.hero-stats {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 14px;
}
.hero-stat {
    padding: 16px 18px;
    border-radius: 18px;
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.05);
}
.hero-stat-label {
    display: block;
    font-size: 11px;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: rgba(255,255,255,0.5);
    margin-bottom: 10px;
}
.hero-stat strong {
    font-size: 20px;
}
.hero-panel {
    padding: 34px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    background:
        radial-gradient(circle at top right, rgba(124,255,107,0.16), transparent 28%),
        radial-gradient(circle at bottom left, rgba(0,221,255,0.16), transparent 32%),
        var(--panel-strong);
}
.hero-panel-title {
    margin-top: 16px;
    font-size: 32px;
    line-height: 1.08;
    font-weight: 800;
}
.hero-panel-line {
    width: 92px;
    height: 4px;
    margin: 28px 0 22px;
    border-radius: 999px;
    background: linear-gradient(90deg, var(--accent), var(--accent-2));
}
.catalog-shell {
    padding: 28px;
}
.catalog-toolbar {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 22px;
}
.catalog-toolbar h2 {
    margin: 10px 0 0;
    font-size: 34px;
}
.catalog-grid { min-height: 320px; }
.idle-card {
    margin-bottom: 24px;
    border-radius: 22px;
    overflow: hidden;
    cursor: pointer;
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.06);
    transition: transform .28s ease, box-shadow .28s ease, border-color .28s ease;
}
.idle-card:hover {
    transform: translateY(-8px);
    border-color: rgba(0,221,255,0.34);
    box-shadow: 0 22px 44px rgba(0,0,0,.34);
}
.idle-card-media { position: relative; overflow: hidden; }
.idle-card-price {
    position: absolute;
    left: 14px;
    bottom: 14px;
    padding: 8px 14px;
    border-radius: 999px;
    background: rgba(5,8,22,0.78);
    color: #fff;
    font-weight: 800;
    backdrop-filter: blur(12px);
}
.idle-card-body { padding: 18px 18px 16px; }
.idle-title {
    font-size: 19px;
    font-weight: 800;
    line-height: 1.2;
    min-height: 46px;
}
.idle-meta-row {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    margin-top: 14px;
    color: var(--text-soft);
    font-size: 13px;
}
.user-info {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 18px;
    padding-top: 14px;
    border-top: 1px solid rgba(255,255,255,0.06);
}
.user-nickname { font-size: 13px; color: rgba(255,255,255,0.78); }
.image-slot {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255,255,255,0.03);
    color: rgba(255,255,255,0.45);
}
.image-slot.small { font-size: 11px; }
.fenye { display: flex; justify-content: center; margin-top: 12px; }
@media (max-width: 1080px) {
    .market-hero { grid-template-columns: 1fr; }
    .hero-copy h1 { font-size: 44px; }
}

@media (max-width: 720px) {
    .market-hero {
        padding-bottom: 20px;
    }

    .hero-copy,
    .hero-panel,
    .catalog-shell {
        padding: 22px;
    }

    .hero-copy h1 {
        font-size: 36px;
        line-height: 1;
    }

    .hero-actions,
    .catalog-toolbar,
    .idle-meta-row {
        flex-direction: column;
        align-items: flex-start;
    }

    .hero-actions {
        margin: 24px 0 28px;
    }

    .hero-stats {
        grid-template-columns: 1fr;
    }

    .hero-panel-title,
    .catalog-toolbar h2 {
        font-size: 28px;
    }

    .idle-title {
        min-height: 0;
    }

    .fenye {
        justify-content: flex-start;
        overflow-x: auto;
        padding-bottom: 6px;
    }
}
</style>
