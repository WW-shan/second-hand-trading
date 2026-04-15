<template>
    <div class="admin-data-shell">
        <div class="admin-data-head">
            <div>
                <div class="admin-section-kicker">Order Oversight</div>
                <h2>Every order, payment, and fulfillment state</h2>
            </div>
            <div class="admin-data-note">{{ total }} orders</div>
        </div>

        <el-table :data="Order" stripe class="admin-table">
            <el-table-column prop="orderNumber" label="Order No." show-overflow-tooltip width="200"></el-table-column>
            <el-table-column prop="idleItem.idleName" label="Item Name" show-overflow-tooltip></el-table-column>
            <el-table-column prop="orderPrice" label="Amount" show-overflow-tooltip min-width="100" width="110"></el-table-column>
            <el-table-column prop="createTime" label="Created At" show-overflow-tooltip min-width="150" width="200"></el-table-column>
            <el-table-column label="Order Status" width="140" show-overflow-tooltip>
                <template slot-scope="scope"><div>{{ orderStatus[scope.row.orderStatus] }}</div></template>
            </el-table-column>
            <el-table-column label="Payment Status" width="140" show-overflow-tooltip>
                <template slot-scope="scope"><div>{{ paymentStatus[scope.row.paymentStatus] }}</div></template>
            </el-table-column>
            <el-table-column prop="paymentWay" label="Payment Method" width="140" show-overflow-tooltip></el-table-column>
            <el-table-column prop="paymentTime" label="Paid At" show-overflow-tooltip></el-table-column>
            <el-table-column label="Actions" width="120">
                <template slot-scope="scope"><el-button size="mini" type="danger" @click="deleteOrder(scope.$index)">Delete</el-button></template>
            </el-table-column>
        </el-table>

        <div class="block">
            <el-pagination @current-change="handleCurrentChange" :current-page.sync="nowPage" :page-size="8" background layout="prev, pager, next, jumper" :total="total"></el-pagination>
        </div>
    </div>
</template>
<script>
export default {
    name: 'orderList',
    created() { this.getOrder(); },
    data() {
        return {
            nowPage: 1,
            total: 0,
            paymentStatus: ['Unpaid', 'Paid'],
            orderStatus: ['Pending Payment', 'Pending Shipment', 'Pending Delivery', 'Completed', 'Canceled'],
            Order: []
        };
    },
    methods: {
        getOrder() {
            this.$api.getOrderList({ page: this.nowPage, nums: 8 }).then(res => {
                if (res.status_code === 1) {
                    this.Order = res.data.list;
                    this.total = res.data.count;
                } else this.$message.error(res.msg);
            }).catch(console.log);
        },
        deleteOrder(index) {
            this.$api.deleteOrder({ id: this.Order[index].id }).then(res => {
                if (res.status_code === 1) this.getOrder();
                else this.$message.error(res.msg);
            }).catch(console.log);
        },
        handleCurrentChange(val) {
            this.nowPage = val;
            this.getOrder();
        }
    }
};
</script>
<style scoped>
.admin-data-shell { display: grid; gap: 18px; }
.admin-data-head { display: flex; justify-content: space-between; align-items: flex-end; gap: 16px; }
.admin-section-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.admin-data-head h2 { margin: 10px 0 0; font-size: 28px; max-width: 720px; }
.admin-data-note { color: var(--text-soft); padding: 12px 14px; border-radius: 16px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.06); }
.admin-table { width: 100%; }
.block { display: flex; justify-content: center; padding-top: 6px; }
@media (max-width: 860px) { .admin-data-head { flex-direction: column; align-items: flex-start; } }
</style>
