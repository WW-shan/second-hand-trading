<template>
    <div class="admin-data-shell">
        <div class="admin-data-head">
            <div>
                <div class="admin-section-kicker">User Control</div>
                <h2>{{ panelTitle }}</h2>
            </div>
            <div class="admin-actions" v-if="mode === 3">
                <el-button type="primary" @click="adminRegVisible = true">Add Admin</el-button>
            </div>
        </div>

        <el-menu default-active="1" class="admin-panel-menu" mode="horizontal" @select="handleSelect">
            <el-menu-item index="1">Active Users</el-menu-item>
            <el-menu-item index="2">Blocked Users</el-menu-item>
            <el-menu-item index="3">Administrators</el-menu-item>
        </el-menu>

        <el-dialog title="Add Admin" :visible.sync="adminRegVisible" width="420px">
            <span class="dialog-label">Admin Name</span>
            <el-input v-model="adminName" maxlength="8" placeholder="Enter admin name" class="dialog-input" clearable required></el-input>
            <span class="dialog-label">Admin Account</span>
            <el-input v-model="adminAccount" minlength="8" maxlength="10" placeholder="Enter admin account" class="dialog-input" clearable required></el-input>
            <span class="dialog-label">Admin Password</span>
            <el-input v-model="adminPassword" minlength="8" placeholder="Enter admin password" class="dialog-input" show-password required></el-input>
            <span class="dialog-label">Confirm Admin Password</span>
            <el-input v-model="adminRePassword" minlength="10" placeholder="Re-enter admin password" class="dialog-input" show-password required></el-input>
            <span slot="footer" class="dialog-footer"><el-button type="primary" @click="regAdmin">Add</el-button></span>
        </el-dialog>

        <el-table v-show="mode === 1" :data="userData" stripe class="admin-table">
            <el-table-column label="Avatar" width="72"><template slot-scope="scope"><el-avatar shape="square" :size="28" :src="scope.row.avatar"></el-avatar></template></el-table-column>
            <el-table-column prop="accountNumber" label="User Account" show-overflow-tooltip min-width="150" width="150"></el-table-column>
            <el-table-column prop="nickname" label="Nickname" show-overflow-tooltip min-width="150" width="150"></el-table-column>
            <el-table-column prop="signInTime" label="Registered At" show-overflow-tooltip width="200"></el-table-column>
            <el-table-column label="Actions" width="120"><template slot-scope="scope"><el-button size="mini" type="danger" @click="sealUser(scope.$index)">Block</el-button></template></el-table-column>
        </el-table>

        <el-table v-show="mode === 2" :data="badUserData" stripe class="admin-table">
            <el-table-column label="Avatar" width="72"><template slot-scope="scope"><el-avatar shape="square" :size="28" :src="scope.row.avatar"></el-avatar></template></el-table-column>
            <el-table-column prop="accountNumber" label="User Account" show-overflow-tooltip min-width="150" width="150"></el-table-column>
            <el-table-column prop="nickname" label="Nickname" show-overflow-tooltip width="150"></el-table-column>
            <el-table-column prop="signInTime" label="Registered At" show-overflow-tooltip width="200"></el-table-column>
            <el-table-column label="Actions" width="120"><template slot-scope="scope"><el-button size="mini" type="success" @click="unsealUser(scope.$index)">Unblock</el-button></template></el-table-column>
        </el-table>

        <el-table v-show="mode === 3" :data="userManage" stripe class="admin-table">
            <el-table-column prop="accountNumber" label="Admin Account" show-overflow-tooltip width="200"></el-table-column>
            <el-table-column prop="adminName" label="Admin Name"></el-table-column>
        </el-table>

        <div class="block"><el-pagination @current-change="handleCurrentChange" :current-page.sync="nowPage" :page-size="7" background layout="prev, pager, next, jumper" :total="total"></el-pagination></div>
    </div>
</template>
<script>
export default {
    name: 'userList',
    created() { this.getUserData(); },
    data() {
        return { mode: 1, nowPage: 1, total: 63, adminRegVisible: false, adminAccount: '', adminPassword: '', adminRePassword: '', adminName: '', userData: [], badUserData: [], userManage: [] };
    },
    computed: {
        panelTitle() {
            return {
                1: 'Monitor active marketplace users',
                2: 'Review blocked accounts',
                3: 'Manage administrator access'
            }[this.mode];
        }
    },
    methods: {
        handleCurrentChange(val) {
            this.nowPage = val;
            if (this.mode === 1) this.getUserData();
            if (this.mode === 2) this.getBadUserData();
            if (this.mode === 3) this.getUserManage();
        },
        handleSelect(val) {
            const nextMode = Number(val);
            if (this.mode !== nextMode) {
                this.mode = nextMode;
                this.nowPage = 1;
                if (nextMode === 1) this.getUserData();
                if (nextMode === 2) this.getBadUserData();
                if (nextMode === 3) this.getUserManage();
            }
        },
        getUserData() {
            this.$api.getUserData({ page: this.nowPage, nums: 8, status: 0 }).then(res => {
                if (res.status_code === 1) { this.userData = res.data.list; this.total = res.data.count; }
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        getBadUserData() {
            this.$api.getUserData({ page: this.nowPage, nums: 8, status: 1 }).then(res => {
                if (res.status_code === 1) { this.badUserData = res.data.list; this.total = res.data.count; }
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        getUserManage() {
            this.$api.getUserManage({ page: this.nowPage, nums: 8 }).then(res => {
                if (res.status_code === 1) { this.userManage = res.data.list; this.total = res.data.count; }
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        sealUser(i) {
            this.$api.updateUserStatus({ id: this.userData[i].id, status: 1 }).then(res => {
                if (res.status_code === 1) this.getUserData();
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        unsealUser(i) {
            this.$api.updateUserStatus({ id: this.badUserData[i].id, status: 0 }).then(res => {
                if (res.status_code === 1) this.getBadUserData();
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        regAdmin() {
            if (this.adminPassword === this.adminRePassword) {
                this.$api.regAdministrator({ adminName: this.adminName, accountNumber: this.adminAccount, adminPassword: this.adminPassword }).then(res => {
                    if (res.status_code === 1) {
                        this.total += 1;
                        this.nowPage = Math.ceil(this.total / 8);
                        this.getUserManage();
                        this.adminName = '';
                        this.adminAccount = '';
                        this.adminPassword = '';
                        this.adminRePassword = '';
                    } else this.$message.error(res.msg);
                }).catch(() => {
                    this.$message.error('Failed to add admin. Duplicate account or network error.');
                });
                this.adminRegVisible = false;
            } else {
                this.$message.error('Passwords do not match.');
            }
        }
    }
};
</script>
<style scoped>
.admin-data-shell { display: grid; gap: 18px; }
.admin-data-head { display: flex; justify-content: space-between; align-items: flex-end; gap: 16px; }
.admin-section-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.admin-data-head h2 { margin: 10px 0 0; font-size: 28px; }
.admin-panel-menu { border: none !important; background: transparent !important; }
.admin-actions { display: flex; gap: 12px; }
.dialog-label { display: block; margin-bottom: 8px; color: var(--text-soft); }
.dialog-input { margin-bottom: 14px; }
.admin-table { width: 100%; }
.block { display: flex; justify-content: center; padding-top: 6px; }
@media (max-width: 860px) { .admin-data-head { flex-direction: column; align-items: flex-start; } }
</style>
