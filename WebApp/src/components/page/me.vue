<template>
    <div class="profile-page">
        <app-head :nickname-value="userInfo.nickname" :avatarValue="userInfo.avatar"></app-head>
        <app-body>
            <section v-show="!eidtAddress" class="profile-shell">
                <div class="profile-hero">
                    <div class="profile-main-card">
                        <el-upload
                            :action="uploadUrl"
                            :on-success="fileHandleSuccess"
                            :file-list="imgFileList"
                            accept="image/*"
                            class="profile-avatar-upload"
                        >
                            <el-image class="profile-avatar" :src="userInfo.avatar" fit="cover"></el-image>
                        </el-upload>
                        <div class="profile-avatar-note">Click the avatar to refresh your profile photo.</div>
                        <div class="profile-copy">
                            <div class="profile-kicker">Member Profile</div>
                            <div class="profile-name">{{ userInfo.nickname }}</div>
                            <div class="profile-time">{{ userInfo.signInTime }} joined the platform</div>
                            <div class="profile-actions">
                                <el-button type="primary" @click="userInfoDialogVisible = true">Edit Profile</el-button>
                                <el-button plain @click="eidtAddress = true">Manage Addresses</el-button>
                            </div>
                        </div>
                    </div>
                    <div class="profile-stats-card">
                        <div class="stat-card"><span>Listings</span><strong>{{ dataList[0].length }}</strong></div>
                        <div class="stat-card"><span>Favorites</span><strong>{{ dataList[2].length }}</strong></div>
                        <div class="stat-card"><span>Sold</span><strong>{{ dataList[3].length }}</strong></div>
                        <div class="stat-card"><span>Purchases</span><strong>{{ dataList[4].length }}</strong></div>
                    </div>
                </div>

                <el-dialog @close="finishEdit" title="Edit Profile" :visible.sync="userInfoDialogVisible" width="420px">
                    <div class="edit-tip">Nickname</div>
                    <el-input v-model="userInfo.nickname" :disabled="notUserNicknameEdit" @change="saveUserNickname">
                        <el-button slot="append" type="warning" icon="el-icon-edit" @click="notUserNicknameEdit = false">Edit</el-button>
                    </el-input>
                    <div v-if="userPasswordEdit">
                        <div class="edit-tip">Current Password</div>
                        <el-input v-model="userPassword1" show-password></el-input>
                        <div class="edit-tip">New Password</div>
                        <el-input v-model="userPassword2" show-password></el-input>
                        <div class="edit-tip">Confirm New Password</div>
                        <el-input v-model="userPassword3" show-password></el-input>
                        <div class="edit-tip"></div>
                        <el-button @click="savePassword" plain>Confirm Update</el-button>
                    </div>
                    <div v-else>
                        <div class="edit-tip">Password</div>
                        <el-input value="123456" :disabled="true" show-password>
                            <el-button slot="append" type="warning" icon="el-icon-edit" @click="userPasswordEdit = true">Edit</el-button>
                        </el-input>
                    </div>
                    <span slot="footer" class="dialog-footer"><el-button @click="userInfoDialogVisible = false">Done</el-button></span>
                </el-dialog>

                <section class="inventory-shell">
                    <div class="inventory-head">
                        <div>
                            <div class="page-kicker">Inventory Control</div>
                            <h2>{{ activePaneTitle }}</h2>
                            <div class="inventory-head-note">{{ activePaneDescription }}</div>
                        </div>
                    </div>
                    <el-tabs v-model="activeName" class="inventory-tabs" @tab-click="handleClick">
                        <el-tab-pane label="My Listings" name="1"></el-tab-pane>
                        <el-tab-pane label="Removed Listings" name="2"></el-tab-pane>
                        <el-tab-pane label="My Favorites" name="3"></el-tab-pane>
                        <el-tab-pane label="Items I Sold" name="4"></el-tab-pane>
                        <el-tab-pane label="Items I Bought" name="5"></el-tab-pane>
                    </el-tabs>
                    <div class="inventory-list">
                        <article v-if="activeItems.length === 0" class="inventory-empty">
                            <div class="inventory-empty-title">{{ emptyState.title }}</div>
                            <div class="inventory-empty-text">{{ emptyState.description }}</div>
                        </article>
                        <article v-for="(item,index) in activeItems" :key="`${activeName}-${item.id}-${index}`" class="inventory-item">
                            <div class="inventory-item-detile" @click="toDetails(activeName, item)">
                                <el-image class="inventory-image" :src="item.imgUrl" fit="cover">
                                    <div slot="error" class="image-slot"><i class="el-icon-picture-outline">No Image</i></div>
                                </el-image>
                                <div class="inventory-copy">
                                    <div class="inventory-title">{{ item.idleName }}</div>
                                    <div class="inventory-details" v-html="item.idleDetails">{{ item.idleDetails }}</div>
                                    <div class="inventory-time">{{ item.timeStr }}</div>
                                </div>
                                <div class="inventory-side">
                                    <div v-if="item.orderStatus !== undefined" class="inventory-chip">{{ orderStatus[item.orderStatus] }}</div>
                                    <div class="inventory-price">${{ item.idlePrice }} <span class="inventory-status">{{ (activeName === '4' || activeName === '5') ? orderStatus[item.orderStatus] : '' }}</span></div>
                                    <el-button v-if="activeName !== '4' && activeName !== '5'" type="danger" size="mini" plain @click.stop="handle(activeName, item, index)">{{ handleName[activeName-1] }}</el-button>
                                </div>
                            </div>
                        </article>
                    </div>
                </section>
            </section>

            <section v-show="eidtAddress" class="address-shell">
                <el-page-header class="address-container-back" @back="eidtAddress = false" content="Shipping Address"></el-page-header>
                <div class="address-grid">
                    <div class="address-form-card">
                        <div class="address-card-title">Add Shipping Address</div>
                        <div class="address-container-add-item">
                            <el-input placeholder="Enter recipient name" v-model="addressInfo.consigneeName" maxlength="10" show-word-limit>
                                <div slot="prepend">Recipient</div>
                            </el-input>
                        </div>
                        <div class="address-container-add-item">
                            <el-input placeholder="Enter recipient phone" v-model="addressInfo.consigneePhone" onkeyup="this.value=this.value.replace(/[^\d.]/g,'');" maxlength="11" show-word-limit>
                                <div slot="prepend">Phone</div>
                            </el-input>
                        </div>
                        <div class="address-container-add-item">
                            <span class="demonstration">Province / City / District</span>
                            <el-cascader :options="options" v-model="selectedOptions" @change="handleAddressChange" :separator="' '"></el-cascader>
                        </div>
                        <div class="address-container-add-item">
                            <el-input placeholder="Enter full address (street, building, unit, etc.)" v-model="addressInfo.detailAddress" maxlength="50" show-word-limit>
                                <div slot="prepend">Detailed Address</div>
                            </el-input>
                        </div>
                        <el-checkbox v-model="addressInfo.defaultFlag">Set as default address</el-checkbox>
                        <div class="address-save-row"><el-button type="primary" @click="saveAddress">Save</el-button></div>
                    </div>
                    <div class="address-list-card">
                        <div class="address-card-title">Saved Addresses</div>
                        <div v-if="addressData.length === 0" class="address-empty">No shipping addresses yet. Add one to make checkout faster.</div>
                        <el-table stripe :data="addressData" style="width: 100%">
                            <el-table-column prop="consigneeName" label="Recipient" width="120"></el-table-column>
                            <el-table-column prop="consigneePhone" label="Phone" width="140"></el-table-column>
                            <el-table-column prop="detailAddressText" label="Address"></el-table-column>
                            <el-table-column label="Actions">
                                <template slot-scope="scope">
                                    <el-button size="mini" @click="handleEdit(scope.$index, scope.row)">Edit</el-button>
                                    <el-button size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">Delete</el-button>
                                </template>
                            </el-table-column>
                            <el-table-column label="Default?" width="120">
                                <template slot-scope="scope">
                                    <el-button v-if="!scope.row.defaultFlag" size="mini" @click="handleSetDefault(scope.$index, scope.row)">Set Default</el-button>
                                    <div v-else class="default-badge">{{ scope.row.defaultAddress }}</div>
                                </template>
                            </el-table-column>
                        </el-table>
                    </div>
                </div>
            </section>
            <app-foot></app-foot>
        </app-body>
    </div>
</template>

<script>
import AppHead from '../common/AppHeader.vue'
import AppBody from '../common/AppPageBody.vue'
import AppFoot from '../common/AppFoot.vue'
import options from '../common/country-data.js'
import { UPLOAD_URL } from '../../config'

export default {
    name: 'me',
    components: { AppHead, AppBody, AppFoot },
    data() {
        return {
            uploadUrl: UPLOAD_URL,
            imgFileList: [],
            addressInfo: { consigneeName: '', consigneePhone: '', provinceName: '', cityName: '', regionName: '', detailAddress: '', defaultFlag: false },
            activeName: '1',
            handleName: ['Remove Listing', 'Delete', 'Remove Favorite', '', ''],
            dataList: [[], [], [], [], [], [], [], []],
            orderStatus: ['Pending Payment', 'Pending Shipment', 'Pending Delivery', 'Completed', 'Canceled'],
            userInfoDialogVisible: false,
            notUserNicknameEdit: true,
            userPasswordEdit: false,
            userPassword1: '',
            userPassword2: '',
            userPassword3: '',
            eidtAddress: false,
            selectedOptions: [],
            options,
            userInfo: { accountNumber: '', avatar: '', nickname: '', signInTime: '' },
            addressData: []
        }
    },
    computed: {
        activeItems() {
            return this.dataList[Number(this.activeName) - 1] || []
        },
        activePaneTitle() {
            return {
                '1': 'Everything currently live in your storefront.',
                '2': 'Listings you have already taken offline.',
                '3': 'Favorites you may want to revisit.',
                '4': 'Orders you fulfilled for other buyers.',
                '5': 'Orders you placed as a buyer.'
            }[this.activeName]
        },
        activePaneDescription() {
            return {
                '1': 'Manage visibility, check pricing, and keep your live catalog clean.',
                '2': 'Delete old items or relist them when demand comes back.',
                '3': 'A private shortlist of products worth tracking.',
                '4': 'Monitor sold inventory and shipping progress from one view.',
                '5': 'Review every purchase without jumping across pages.'
            }[this.activeName]
        },
        emptyState() {
            return {
                '1': {
                    title: 'No live listings yet',
                    description: 'Publish your first item to start building your storefront.'
                },
                '2': {
                    title: 'No removed listings',
                    description: 'Anything you take offline will appear here for later cleanup.'
                },
                '3': {
                    title: 'No favorites saved',
                    description: 'Tap the favorite button on a listing to keep it in your shortlist.'
                },
                '4': {
                    title: 'No sold items yet',
                    description: 'Completed sales will show here once buyers start checking out.'
                },
                '5': {
                    title: 'No purchases yet',
                    description: 'Orders you place will appear here for payment and delivery tracking.'
                }
            }[this.activeName]
        }
    },
    created() {
        this.$ensureUserSession().then(userInfo => {
            this.userInfo = userInfo
        }).catch(() => {})
        this.getAddressData()
        this.getIdleItemData()
        this.getMyOrder()
        this.getMySoldIdle()
        this.getMyFavorite()
    },
    methods: {
        getMyFavorite() {
            this.$set(this.dataList, 2, [])
            this.$api.getMyFavorite().then(res => {
                if (res.status_code === 1) {
                    for (let i = 0; i < res.data.length; i++) {
                        let pictureList = JSON.parse(res.data[i].idleItem.pictureList)
                        this.dataList[2].push({
                            favoriteId: res.data[i].id,
                            id: res.data[i].idleItem.id,
                            imgUrl: pictureList.length > 0 ? pictureList[0] : '',
                            idleName: res.data[i].idleItem.idleName,
                            idleDetails: res.data[i].idleItem.idleDetails,
                            timeStr: res.data[i].createTime.substring(0, 10) + ' ' + res.data[i].createTime.substring(11, 19),
                            idlePrice: res.data[i].idleItem.idlePrice
                        })
                    }
                    this.$forceUpdate()
                }
            })
        },
        getMySoldIdle() {
            this.$set(this.dataList, 3, [])
            this.$api.getMySoldIdle().then(res => {
                if (res.status_code === 1) {
                    for (let i = 0; i < res.data.length; i++) {
                        let pictureList = JSON.parse(res.data[i].idleItem.pictureList)
                        this.dataList[3].push({
                            id: res.data[i].id,
                            imgUrl: pictureList.length > 0 ? pictureList[0] : '',
                            idleName: res.data[i].idleItem.idleName,
                            idleDetails: res.data[i].idleItem.idleDetails,
                            timeStr: res.data[i].createTime.substring(0, 10) + ' ' + res.data[i].createTime.substring(11, 19),
                            idlePrice: res.data[i].orderPrice,
                            orderStatus: res.data[i].orderStatus
                        })
                    }
                    this.$forceUpdate()
                }
            })
        },
        getMyOrder() {
            this.$set(this.dataList, 4, [])
            this.$api.getMyOrder().then(res => {
                if (res.status_code === 1) {
                    for (let i = 0; i < res.data.length; i++) {
                        let pictureList = JSON.parse(res.data[i].idleItem.pictureList)
                        this.dataList[4].push({
                            id: res.data[i].id,
                            imgUrl: pictureList.length > 0 ? pictureList[0] : '',
                            idleName: res.data[i].idleItem.idleName,
                            idleDetails: res.data[i].idleItem.idleDetails,
                            timeStr: res.data[i].createTime.substring(0, 10) + ' ' + res.data[i].createTime.substring(11, 19),
                            idlePrice: res.data[i].orderPrice,
                            orderStatus: res.data[i].orderStatus
                        })
                    }
                    this.$forceUpdate()
                }
            })
        },
        getIdleItemData() {
            this.$set(this.dataList, 0, [])
            this.$set(this.dataList, 1, [])
            this.$api.getAllIdleItem().then(res => {
                if (res.status_code === 1) {
                    for (let i = 0; i < res.data.length; i++) {
                        res.data[i].timeStr = res.data[i].releaseTime.substring(0, 10) + ' ' + res.data[i].releaseTime.substring(11, 19)
                        let pictureList = JSON.parse(res.data[i].pictureList)
                        res.data[i].imgUrl = pictureList.length > 0 ? pictureList[0] : ''
                        if (res.data[i].idleStatus === 1) this.dataList[0].push(res.data[i])
                        else if (res.data[i].idleStatus === 2) this.dataList[1].push(res.data[i])
                    }
                    this.$forceUpdate()
                }
            })
        },
        getAddressData() {
            this.$api.getAddress().then(res => {
                if (res.status_code === 1) {
                    let data = res.data
                    for (let i = 0; i < data.length; i++) {
                        data[i].detailAddressText = data[i].provinceName + data[i].cityName + data[i].regionName + data[i].detailAddress
                        data[i].defaultAddress = data[i].defaultFlag ? 'Default Address' : 'Set Default'
                    }
                    this.addressData = data
                }
            })
        },
        handleClick() {},
        saveUserNickname() {
            this.notUserNicknameEdit = true
            this.$api.updateUserPublicInfo({ nickname: this.userInfo.nickname }).then(() => {
                this.$globalData.userInfo.nickname = this.userInfo.nickname
            })
        },
        savePassword() {
            if (!this.userPassword1 || !this.userPassword2) {
                this.$message.error('Password cannot be empty!')
            } else if (this.userPassword2 === this.userPassword3) {
                this.$api.updatePassword({ oldPassword: this.userPassword1, newPassword: this.userPassword2 }).then(res => {
                    if (res.status_code === 1) {
                        this.userPasswordEdit = false
                        this.$message({ message: 'Updated successfully!', type: 'success' })
                        this.userPassword1 = ''
                        this.userPassword2 = ''
                        this.userPassword3 = ''
                    } else {
                        this.$message.error('Current password is incorrect.')
                    }
                })
            } else {
                this.$message.error('Passwords do not match!')
            }
        },
        finishEdit() {
            this.notUserNicknameEdit = true
            this.userInfoDialogVisible = false
            this.userPasswordEdit = false
        },
        handleAddressChange(value) {
            this.addressInfo.provinceName = value[0]
            this.addressInfo.cityName = value[1]
            this.addressInfo.regionName = value[2]
        },
        handleEdit(index, row) {
            this.addressInfo = JSON.parse(JSON.stringify(row))
            this.selectedOptions = ['', '', '']
            this.selectedOptions[0] = row.provinceName
            this.selectedOptions[1] = row.cityName
            this.selectedOptions[2] = row.regionName
        },
        handleDelete(index, row) {
            this.$confirm('Delete this address?', 'Notice', { confirmButtonText: 'Confirm', cancelButtonText: 'Cancel', type: 'warning' }).then(() => {
                this.$api.deleteAddress(row).then(res => {
                    if (res.status_code === 1) {
                        this.$message({ message: 'Deleted successfully!', type: 'success' })
                        this.addressData.splice(index, 1)
                        if (row.defaultFlag && this.addressData.length > 0) {
                            this.addressData[0].defaultFlag = true
                            this.addressData[0].defaultAddress = 'Default Address'
                            this.update({ id: this.addressData[0].id, defaultFlag: true })
                        }
                    } else {
                        this.$message.error('System error. Delete failed!')
                    }
                }).catch(() => this.$message.error('Network error!'))
            }).catch(() => {})
        },
        handleSetDefault(index, row) {
            row.defaultFlag = true
            this.update(row)
        },
        toDetails(activeName, item) {
            if (activeName === '4' || activeName === '5') this.$router.push({ path: '/order', query: { id: item.id } })
            else this.$router.push({ path: '/details', query: { id: item.id } })
        },
        handle(activeName, item, index) {
            this.$confirm('Are you sure?', 'Notice', { confirmButtonText: 'Confirm', cancelButtonText: 'Cancel', type: 'warning' }).then(() => {
                if (activeName === '1') {
                    this.$api.updateIdleItem({ id: item.id, idleStatus: 2 }).then(res => {
                        if (res.status_code === 1) {
                            this.dataList[0].splice(index, 1)
                            item.idleStatus = 2
                            this.dataList[1].unshift(item)
                        } else this.$message.error(res.msg)
                    })
                } else if (activeName === '2') {
                    this.$api.updateIdleItem({ id: item.id, idleStatus: 0 }).then(res => {
                        if (res.status_code === 1) this.dataList[1].splice(index, 1)
                        else this.$message.error(res.msg)
                    })
                } else if (activeName === '3') {
                    this.$api.deleteFavorite({ id: item.favoriteId }).then(res => {
                        if (res.status_code === 1) {
                            this.$message({ message: 'Removed from favorites!', type: 'success' })
                            this.dataList[2].splice(index, 1)
                        } else this.$message.error(res.msg)
                    }).catch(() => {})
                }
            }).catch(() => {})
        },
        fileHandleSuccess(response) {
            let imgUrl = response.data
            this.imgFileList = []
            this.$api.updateUserPublicInfo({ avatar: imgUrl }).then(() => {
                this.userInfo.avatar = imgUrl
                this.$globalData.userInfo.avatar = imgUrl
            })
        },
        update(data) {
            this.$api.updateAddress(data).then(res => {
                if (res.status_code === 1) {
                    this.getAddressData()
                    this.$message({ message: 'Updated successfully!', type: 'success' })
                } else this.$message.error('System error. Update failed!')
            }).catch(() => this.$message.error('Network error!'))
        },
        saveAddress() {
            if (this.addressInfo.id) {
                this.update(this.addressInfo)
                this.addressInfo = { consigneeName: '', consigneePhone: '', provinceName: '', cityName: '', regionName: '', detailAddress: '', defaultFlag: false }
                this.selectedOptions = []
            } else {
                if (this.addressData.length >= 5) {
                    this.$message.error('Maximum number of addresses reached!')
                } else {
                    this.$api.addAddress(this.addressInfo).then(res => {
                        if (res.status_code === 1) {
                            this.getAddressData()
                            this.$message({ message: 'Added successfully!', type: 'success' })
                            this.selectedOptions = []
                            this.addressInfo = { consigneeName: '', consigneePhone: '', provinceName: '', cityName: '', regionName: '', detailAddress: '', defaultFlag: false }
                        } else this.$message.error('System error. Add failed!')
                    }).catch(() => this.$message.error('Network error!'))
                }
            }
        }
    }
}
</script>

<style scoped>
.profile-hero,
.inventory-shell,
.address-shell,
.profile-main-card,
.profile-stats-card,
.address-form-card,
.address-list-card {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}
.profile-hero { display: grid; grid-template-columns: 1.15fr 0.85fr; gap: 24px; margin-bottom: 24px; }
.profile-main-card { display: flex; align-items: center; gap: 22px; padding: 28px; }
.profile-avatar-upload { flex-shrink: 0; }
.profile-avatar { width: 132px; height: 132px; border-radius: 28px; overflow: hidden; }
.profile-avatar-note { margin-right: 4px; color: var(--text-soft); font-size: 12px; line-height: 1.6; max-width: 140px; }
.profile-kicker,
.page-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.profile-name { margin-top: 10px; font-size: 38px; font-weight: 800; }
.profile-time { margin-top: 10px; color: var(--text-soft); }
.profile-actions { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 22px; }
.profile-stats-card { padding: 24px; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
.stat-card { padding: 18px; border-radius: 18px; background: rgba(255,255,255,0.04); }
.stat-card span { display: block; color: var(--text-soft); font-size: 12px; text-transform: uppercase; letter-spacing: 0.14em; }
.stat-card strong { display: block; margin-top: 10px; font-size: 26px; }
.inventory-shell { padding: 28px; }
.inventory-head h2 { margin: 12px 0 0; font-size: 34px; }
.inventory-head-note { margin-top: 10px; color: var(--text-soft); line-height: 1.7; max-width: 760px; }
.inventory-tabs { margin: 18px 0 8px; }
.inventory-item { border-bottom: 1px solid rgba(255,255,255,0.06); }
.inventory-item:last-child { border-bottom: none; }
.inventory-empty {
    padding: 38px 14px;
    text-align: center;
    border: 1px dashed rgba(255,255,255,0.12);
    border-radius: 22px;
    margin-top: 8px;
    background: rgba(255,255,255,0.02);
}
.inventory-empty-title { font-size: 20px; font-weight: 800; }
.inventory-empty-text { margin-top: 10px; color: var(--text-soft); line-height: 1.7; }
.inventory-item-detile { display: grid; grid-template-columns: 120px 1fr auto; gap: 18px; align-items: center; min-height: 148px; cursor: pointer; }
.inventory-image { width: 120px; height: 120px; border-radius: 20px; overflow: hidden; }
.inventory-title { font-size: 20px; font-weight: 800; }
.inventory-details {
    margin-top: 8px;
    color: var(--text-soft);
    overflow: hidden;
    line-height: 1.7;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}
.inventory-time { margin-top: 12px; color: rgba(255,255,255,0.45); font-size: 12px; }
.inventory-side { display: flex; flex-direction: column; align-items: flex-end; gap: 12px; }
.inventory-chip {
    padding: 7px 10px;
    border-radius: 999px;
    background: rgba(0,221,255,0.12);
    color: #dffbff;
    font-size: 12px;
    font-weight: 700;
}
.inventory-price { font-size: 22px; font-weight: 800; }
.inventory-status { display: block; margin-top: 6px; font-size: 12px; color: var(--text-soft); }
.address-shell { padding: 26px; }
.address-grid { display: grid; grid-template-columns: 0.9fr 1.1fr; gap: 24px; margin-top: 18px; }
.address-form-card,.address-list-card { padding: 24px; }
.address-card-title { font-size: 22px; font-weight: 800; margin-bottom: 18px; }
.address-empty { margin-bottom: 18px; color: var(--text-soft); line-height: 1.7; }
.address-container-add-item { margin-bottom: 18px; }
.demonstration { display: block; color: var(--text-soft); font-size: 13px; margin-bottom: 10px; }
.address-save-row { margin-top: 18px; }
.default-badge { color: var(--accent); font-weight: 700; }
.image-slot { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: rgba(255,255,255,0.03); color: rgba(255,255,255,0.45); }
.edit-tip { font-size: 13px; margin: 10px 4px; color: var(--text-soft); }
@media (max-width: 980px) {
    .profile-hero,.address-grid { grid-template-columns: 1fr; }
    .profile-main-card { flex-wrap: wrap; }
    .inventory-item-detile { grid-template-columns: 1fr; align-items: flex-start; padding: 18px 0; }
    .inventory-side { align-items: flex-start; }
}

@media (max-width: 720px) {
    .profile-main-card,
    .inventory-shell,
    .address-shell,
    .address-form-card,
    .address-list-card {
        padding: 22px;
    }

    .profile-name,
    .inventory-head h2 {
        font-size: 30px;
    }

    .profile-stats-card {
        grid-template-columns: 1fr;
    }

    .profile-avatar-note {
        max-width: none;
    }
}
</style>
