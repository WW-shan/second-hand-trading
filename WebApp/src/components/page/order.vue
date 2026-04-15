<template>
    <div class="order-page">
        <app-head></app-head>
        <app-body>
            <section class="order-hero">
                <div>
                    <div class="page-kicker">Transaction Control</div>
                    <h1>Track every step from cart to delivery.</h1>
                </div>
                <div class="order-status-pill">{{ orderStatus[orderInfo.orderStatus] }}</div>
            </section>

            <section class="order-shell">
                <div class="order-grid">
                    <article class="order-summary-card" @click="toDetails(orderInfo.idleItem.id)">
                        <el-image class="summary-image" :src="orderInfo.idleItem.imgUrl" fit="cover"></el-image>
                        <div class="summary-copy">
                            <div class="summary-type">{{ orderInfo.userId == userId ? 'Purchased Item' : 'Sold Item' }}</div>
                            <h2>{{ orderInfo.idleItem.idleName }}</h2>
                            <div class="summary-price">${{ orderInfo.orderPrice }}</div>
                        </div>
                    </article>

                    <article class="order-meta-card">
                        <div class="order-card-title">Order Details</div>
                        <div class="order-info-item">Order No.: {{ orderInfo.orderNumber }}</div>
                        <div class="order-info-item">Payment Status: {{ orderInfo.paymentStatus === 0 ? 'Unpaid' : 'Paid' }}</div>
                        <div class="order-info-item">Payment Method: {{ orderInfo.paymentWay }}</div>
                        <div class="order-info-item">Created At: {{ orderInfo.createTime.substring(0, 10) + ' ' + orderInfo.createTime.substring(11, 19) }}</div>
                        <div class="order-info-item">Paid At: {{ orderInfo.paymentTime ? orderInfo.paymentTime.substring(0, 10) + ' ' + orderInfo.paymentTime.substring(11, 19) : '' }}</div>
                    </article>
                </div>

                <article class="address-card" @click.stop="selectAddressDialog" :style="orderInfo.userId == userId && orderInfo.orderStatus === 0 ? 'cursor: pointer;' : ''">
                    <div class="order-card-title">Shipping Address</div>
                    <div class="address-title">{{ addressInfo.consigneeName }} {{ addressInfo.consigneePhone }}</div>
                    <div class="address-detials">{{ addressInfo.detailAddress }}</div>
                    <el-button v-if="!addressInfo.detailAddress" type="primary" plain @click.stop="selectAddressDialog">Select Shipping Address</el-button>
                </article>

                <el-dialog title="Select Address" :visible.sync="addressDialogVisible" width="800px">
                    <el-table stripe empty-text="No address found. Please add one in your profile first." :data="addressData" style="width: 100%">
                        <el-table-column prop="consigneeName" label="Recipient" width="120"></el-table-column>
                        <el-table-column prop="consigneePhone" label="Phone" width="140"></el-table-column>
                        <el-table-column prop="detailAddressText" label="Address"></el-table-column>
                        <el-table-column label=" " width="120">
                            <template slot-scope="scope"><el-button size="mini" @click="selectAddress(scope.$index, scope.row)">Select</el-button></template>
                        </el-table-column>
                    </el-table>
                </el-dialog>

                <div class="menu">
                    <el-button v-if="userId == orderInfo.userId && orderInfo.orderStatus === 0" type="danger" plain @click="changeOrderStatus(4, orderInfo)">Cancel Order</el-button>
                    <el-button v-if="userId == orderInfo.userId && orderInfo.orderStatus === 0" type="primary" plain @click="changeOrderStatus(1, orderInfo)">Pay Now</el-button>
                    <el-button v-if="userId == orderInfo.idleItem.userId && orderInfo.orderStatus === 1" type="primary" plain @click="changeOrderStatus(2, orderInfo)">Ship</el-button>
                    <el-button v-if="userId == orderInfo.userId && orderInfo.orderStatus === 2" type="primary" plain @click="changeOrderStatus(3, orderInfo)">Confirm Delivery</el-button>
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

export default {
    name: 'order',
    components: { AppHead, AppBody, AppFoot },
    data() {
        return {
            addressDialogVisible: false,
            addressData: [],
            orderStatus: ['Pending Payment', 'Pending Shipment', 'Pending Delivery', 'Completed', 'Canceled'],
            orderInfo: {
                createTime: '',
                id: 0,
                idleId: 0,
                idleItem: { id: '', idleName: '', idleDetails: '', pictureList: [], imgUrl: '', idlePrice: 0, idlePlace: '', idleLabel: '', idleStatus: -1, userId: '' },
                orderNumber: '',
                orderPrice: 0,
                orderStatus: 0,
                paymentStatus: 0,
                paymentTime: '',
                paymentWay: '',
                userId: 0
            },
            addressInfo: { id: '', update: false, consigneeName: '', consigneePhone: '', detailAddress: '' },
            userId: ''
        };
    },
    created() {
        this.userId = this.getCookie('shUserId');
        const orderId = this.$route.query.id;
        this.$api.getOrder({ id: orderId }).then(res => {
            if (res.status_code === 1) {
                if (res.data.idleItem) {
                    const imgList = JSON.parse(res.data.idleItem.pictureList);
                    res.data.idleItem.imgUrl = imgList.length > 0 ? imgList[0] : '';
                } else {
                    res.data.idleItem = { idleName: '', imgUrl: '' };
                }
                this.orderInfo = res.data;
                this.$api.getOrderAddress({ orderId: this.orderInfo.id }).then(result => {
                    if (result.data) { this.addressInfo = result.data; this.addressInfo.update = true; }
                    else this.getAddressData();
                });
            }
        });
    },
    methods: {
        getCookie(cname) {
            var name = cname + '=';
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i].trim();
                if (c.indexOf(name) === 0) return c.substring(name.length, c.length);
            }
            return '0';
        },
        toDetails(id) { this.$router.replace({ path: 'details', query: { id } }); },
        selectAddressDialog() {
            if (this.orderInfo.userId == this.userId && this.orderInfo.orderStatus === 0) {
                this.addressDialogVisible = true;
                if (this.addressData.length === 0) this.getAddressData();
            }
        },
        getAddressData() {
            this.$api.getAddress().then(res => {
                if (res.status_code === 1) {
                    let data = res.data;
                    for (let i = 0; i < data.length; i++) data[i].detailAddressText = data[i].provinceName + data[i].cityName + data[i].regionName + data[i].detailAddress;
                    this.addressData = data;
                    if (!this.addressInfo.update) {
                        for (let i = 0; i < data.length; i++) if (data[i].defaultFlag) this.selectAddress(i, data[i]);
                    }
                }
            });
        },
        selectAddress(i, item) {
            this.addressDialogVisible = false;
            this.addressInfo.consigneeName = item.consigneeName;
            this.addressInfo.consigneePhone = item.consigneePhone;
            this.addressInfo.detailAddress = item.detailAddressText;
            if (this.addressInfo.update) {
                this.$api.updateOrderAddress({ id: this.addressInfo.id, consigneeName: item.consigneeName, consigneePhone: item.consigneePhone, detailAddress: item.detailAddressText });
            } else {
                this.$api.addOrderAddress({ orderId: this.orderInfo.id, consigneeName: item.consigneeName, consigneePhone: item.consigneePhone, detailAddress: item.detailAddressText }).then(res => {
                    if (res.status_code === 1) { this.addressInfo.update = true; this.addressInfo.id = res.data.id; }
                    else this.$message.error(res.msg);
                });
            }
        },
        changeOrderStatus(orderStatus, orderInfo) {
            if (orderStatus === 1) {
                if (!this.addressInfo.detailAddress) {
                    this.$message.error('Please choose an address!');
                } else {
                    this.$confirm('Simulate Alipay payment. Confirm payment?', 'Pay Order', { confirmButtonText: 'Pay', cancelButtonText: 'Cancel', type: 'warning' }).then(() => {
                        this.$api.updateOrder({ id: orderInfo.id, orderStatus, paymentStatus: 1, paymentWay: 'Alipay' }).then(res => {
                            if (res.status_code === 1) {
                                this.$message({ message: 'Payment successful!', type: 'success' });
                                this.orderInfo.orderStatus = orderStatus;
                                this.orderInfo.paymentStatus = 1;
                                this.orderInfo.paymentWay = 'Alipay';
                                this.orderInfo.paymentTime = res.data.paymentTime;
                            }
                        });
                    }).catch(() => {});
                }
            } else {
                this.$api.updateOrder({ id: orderInfo.id, orderStatus }).then(res => {
                    if (res.status_code === 1) {
                        this.$message({ message: 'Action completed successfully!', type: 'success' });
                        this.orderInfo.orderStatus = orderStatus;
                    }
                });
            }
        }
    }
};
</script>
<style scoped>
.order-hero,
.order-shell,
.order-summary-card,
.order-meta-card,
.address-card {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}
.order-hero { display: flex; justify-content: space-between; align-items: center; padding: 28px 32px; margin-bottom: 24px; }
.page-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.order-hero h1 { margin: 12px 0 0; font-size: 36px; }
.order-status-pill { padding: 14px 18px; border-radius: 16px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.08); font-weight: 800; }
.order-shell { padding: 26px; }
.order-grid { display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 24px; }
.order-summary-card,.order-meta-card,.address-card { padding: 24px; }
.order-summary-card { display: flex; gap: 18px; cursor: pointer; }
.summary-image { width: 170px; height: 170px; border-radius: 20px; overflow: hidden; }
.summary-type { font-size: 11px; letter-spacing: 0.14em; text-transform: uppercase; color: var(--accent); }
.summary-copy h2 { margin: 14px 0 12px; font-size: 28px; line-height: 1.1; }
.summary-price { font-size: 24px; font-weight: 800; color: #fff; }
.order-card-title { font-size: 22px; font-weight: 800; margin-bottom: 16px; }
.order-info-item { margin: 12px 0; color: var(--text-soft); }
.address-card { margin-top: 24px; }
.address-title { font-size: 18px; font-weight: 700; margin-bottom: 10px; }
.address-detials { color: var(--text-soft); }
.menu { margin-top: 24px; display: flex; gap: 12px; flex-wrap: wrap; }
@media (max-width: 980px) { .order-grid { grid-template-columns: 1fr; } .order-summary-card { flex-direction: column; } .summary-image { width: 100%; height: 260px; } }
</style>
