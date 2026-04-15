<template>
    <div class="admin-data-shell">
        <div class="admin-data-head">
            <div>
                <div class="admin-section-kicker">Listing Moderation</div>
                <h2>{{ mode === 1 ? 'Active marketplace listings' : 'Removed listings archive' }}</h2>
            </div>
            <div class="admin-data-note">{{ total }} items</div>
        </div>

        <el-menu default-active="1" class="admin-panel-menu" mode="horizontal" @select="handleSelect">
            <el-menu-item index="1">Listed Items</el-menu-item>
            <el-menu-item index="2">Removed Items</el-menu-item>
        </el-menu>

        <el-table v-if="mode === 1" :data="onlineGoods" stripe class="admin-table">
            <el-table-column prop="releaseTime" label="Published At" width="200"></el-table-column>
            <el-table-column prop="idleName" label="Item Name" show-overflow-tooltip></el-table-column>
            <el-table-column prop="user.nickname" label="Seller" show-overflow-tooltip min-width="100" width="120"></el-table-column>
            <el-table-column prop="idlePrice" label="Price" show-overflow-tooltip min-width="100" width="100"></el-table-column>
            <el-table-column label="Actions" width="170">
                <template slot-scope="scope">
                    <el-button size="mini" type="danger" @click="makeOfflineGoods(scope.$index)">Force Remove</el-button>
                </template>
            </el-table-column>
        </el-table>

        <el-table v-show="mode === 2" :data="OfflineGoods" stripe class="admin-table">
            <el-table-column prop="releaseTime" label="Published At" width="200"></el-table-column>
            <el-table-column prop="idleName" label="Item Name" show-overflow-tooltip></el-table-column>
            <el-table-column prop="user.nickname" label="Seller" show-overflow-tooltip min-width="100" width="120"></el-table-column>
            <el-table-column prop="idlePrice" label="Price" show-overflow-tooltip min-width="100" width="100"></el-table-column>
            <el-table-column label="Actions" width="190">
                <template slot-scope="scope">
                    <el-button size="mini" type="danger" @click="deleteGoods(scope.$index)">Delete Permanently</el-button>
                </template>
            </el-table-column>
        </el-table>

        <div class="block">
            <el-pagination @current-change="handleCurrentChange" :current-page.sync="nowPage" :page-size="8" background layout="prev, pager, next, jumper" :total="total"></el-pagination>
        </div>
    </div>
</template>
<script>
export default {
    name: 'IdleGoods',
    data() {
        return { mode: 1, nowPage: 1, total: 0, onlineGoods: [], OfflineGoods: [] };
    },
    created() { this.getOnlineGoods(); },
    methods: {
        handleCurrentChange(val) {
            this.nowPage = val;
            if (this.mode === 1) this.getOnlineGoods();
            if (this.mode === 2) this.getOfflineGoods();
        },
        handleSelect(val) {
            const nextMode = Number(val);
            if (this.mode !== nextMode) {
                this.mode = nextMode;
                this.nowPage = 1;
                if (nextMode === 1) this.getOnlineGoods();
                if (nextMode === 2) this.getOfflineGoods();
            }
        },
        makeOfflineGoods(i) {
            this.$api.updateGoods({ id: this.onlineGoods[i].id, status: 2 }).then(res => {
                if (res.status_code === 1) this.getOnlineGoods();
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        deleteGoods(i) {
            this.$api.updateGoods({ id: this.OfflineGoods[i].id, status: 0 }).then(res => {
                if (res.status_code === 1) this.getOfflineGoods();
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        getOnlineGoods() {
            this.$api.getGoods({ status: 1, page: this.nowPage, nums: 8 }).then(res => {
                if (res.status_code === 1) {
                    this.onlineGoods = res.data.list;
                    this.total = res.data.count;
                } else this.$message.error(res.msg);
            }).catch(console.log);
        },
        getOfflineGoods() {
            this.$api.getGoods({ status: 2, page: this.nowPage, nums: 8 }).then(res => {
                if (res.status_code === 1) {
                    this.OfflineGoods = res.data.list;
                    this.total = res.data.count;
                } else this.$message.error(res.msg);
            }).catch(console.log);
        }
    }
};
</script>
<style scoped>
.admin-data-shell { display: grid; gap: 18px; }
.admin-data-head { display: flex; justify-content: space-between; align-items: flex-end; gap: 16px; }
.admin-section-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.admin-data-head h2 { margin: 10px 0 0; font-size: 28px; }
.admin-data-note { color: var(--text-soft); padding: 12px 14px; border-radius: 16px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.06); }
.admin-panel-menu { border: none !important; background: transparent !important; }
.admin-table { width: 100%; }
.block { display: flex; justify-content: center; padding-top: 6px; }
@media (max-width: 860px) { .admin-data-head { flex-direction: column; align-items: flex-start; } }
</style>
