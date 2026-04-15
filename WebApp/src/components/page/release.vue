<template>
    <div class="release-page">
        <app-head></app-head>
        <app-body>
            <section class="release-hero">
                <div>
                    <div class="page-kicker">Seller Studio</div>
                    <h1>Launch a listing that looks worth buying.</h1>
                    <p>Fast listing flow, cleaner hierarchy, and visual-first presentation designed to help products convert faster.</p>
                </div>
                <div class="release-side-note">Limit 10 images per listing - clean, sharp, fast.</div>
            </section>

            <section class="release-shell">
                <div class="release-grid">
                    <div class="release-main-card">
                        <div class="release-card-title">Item Basics</div>
                        <el-input placeholder="Enter item name" v-model="idleItemInfo.idleName" maxlength="30" show-word-limit></el-input>
                        <el-input class="release-idle-detiles-text" type="textarea" autosize placeholder="Describe your item..." v-model="idleItemInfo.idleDetails" maxlength="1000" show-word-limit></el-input>

                        <div class="release-row">
                            <div class="release-field">
                                <div class="release-tip">Your Region</div>
                                <el-cascader :options="options" v-model="selectedOptions" @change="handleChange" :separator="' '" style="width: 100%;"></el-cascader>
                            </div>
                            <div class="release-field">
                                <div class="release-tip">Category</div>
                                <el-select v-model="idleItemInfo.idleLabel" placeholder="Select a category" style="width:100%">
                                    <el-option v-for="item in options2" :key="item.value" :label="item.label" :value="item.value"></el-option>
                                </el-select>
                            </div>
                        </div>

                        <div class="release-field wide-price">
                            <div class="release-tip">Ask Price</div>
                            <el-input-number v-model="idleItemInfo.idlePrice" :precision="2" :step="10" :max="10000000"></el-input-number>
                        </div>
                    </div>

                    <div class="release-side-card">
                        <div class="release-card-title">Photo Dropzone</div>
                        <el-upload :action="uploadUrl" :on-preview="fileHandlePreview" :on-remove="fileHandleRemove" :on-success="fileHandleSuccess" :show-file-list="showFileList" :limit="10" :on-exceed="handleExceed" accept="image/*" drag multiple>
                            <i class="el-icon-upload"></i>
                            <div class="el-upload__text">Drop images here, or <em>click to upload</em></div>
                        </el-upload>
                        <div class="release-preview-title">Preview Gallery</div>
                        <div class="picture-list">
                            <el-image v-for="(img,index) in imgList" :key="index" style="width: 100%;margin-bottom: 10px;" fit="cover" :src="img" :preview-src-list="imgList"></el-image>
                        </div>
                        <el-dialog :visible.sync="imgDialogVisible"><img width="100%" :src="dialogImageUrl" alt=""></el-dialog>
                    </div>
                </div>

                <div class="release-submit-row">
                    <el-button type="primary" @click="releaseButton">Publish Item</el-button>
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
import options from '../common/country-data.js';
import { UPLOAD_URL } from '../../config';
export default {
    name: 'release',
    components: { AppHead, AppBody, AppFoot },
    data() {
        return {
            uploadUrl: UPLOAD_URL,
            imgDialogVisible: false,
            dialogImageUrl: '',
            showFileList: true,
            options,
            selectedOptions: [],
            options2: [
                { value: 1, label: 'Digital' },
                { value: 2, label: 'Appliances' },
                { value: 3, label: 'Outdoor' },
                { value: 4, label: 'Books' },
                { value: 5, label: 'Other' }
            ],
            imgList: [],
            idleItemInfo: { idleName: '', idleDetails: '', pictureList: '', idlePrice: 0, idlePlace: '', idleLabel: '' }
        };
    },
    methods: {
        handleChange(value) { this.idleItemInfo.idlePlace = value[1]; },
        fileHandleRemove(file) {
            for (let i = 0; i < this.imgList.length; i++) if (this.imgList[i] === file.response.data) this.imgList.splice(i, 1);
        },
        fileHandlePreview(file) { this.dialogImageUrl = file.response.data; this.imgDialogVisible = true; },
        fileHandleSuccess(response) { this.imgList.push(response.data); },
        releaseButton() {
            this.idleItemInfo.pictureList = JSON.stringify(this.imgList);
            if (this.idleItemInfo.idleName && this.idleItemInfo.idleDetails && this.idleItemInfo.idlePlace && this.idleItemInfo.idleLabel && this.idleItemInfo.idlePrice) {
                this.$api.addIdleItem(this.idleItemInfo).then(res => {
                    if (res.status_code === 1) {
                        this.$message({ message: 'Item published successfully!', type: 'success' });
                        this.$router.replace({ path: '/details', query: { id: res.data.id } });
                    } else {
                        this.$message.error(`Failed to publish item! ${res.msg}`);
                    }
                }).catch(() => this.$message.error('Please complete all required fields.'));
            } else {
                this.$message.error('Please complete all required fields!');
            }
        },
        handleExceed(files, fileList) {
            this.$message.warning(`Limit 10 images. You selected ${files.length} this time, ${files.length + fileList.length} in total.`);
        }
    }
}
</script>
<style scoped>
.release-hero,
.release-shell {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}
.release-hero {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 20px;
    padding: 30px 32px;
    margin-bottom: 24px;
}
.page-kicker { font-size: 12px; letter-spacing: 0.18em; text-transform: uppercase; color: var(--accent); }
.release-hero h1 { margin: 14px 0 10px; font-size: 38px; }
.release-hero p { margin: 0; color: var(--text-soft); line-height: 1.7; max-width: 760px; }
.release-side-note { color: var(--text-soft); max-width: 220px; text-align: right; }
.release-shell { padding: 28px; }
.release-grid { display: grid; grid-template-columns: 1.15fr 0.85fr; gap: 24px; }
.release-main-card,
.release-side-card {
    border-radius: var(--radius-lg);
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(255,255,255,0.06);
    padding: 24px;
}
.release-card-title { font-size: 22px; font-weight: 800; margin-bottom: 18px; }
.release-row { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-top: 18px; }
.release-field { margin-bottom: 18px; }
.release-tip, .release-preview-title { color: var(--text-soft); font-size: 13px; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.12em; }
.wide-price :deep(.el-input-number) { width: 100%; }
.picture-list { margin-top: 18px; }
.release-submit-row { display: flex; justify-content: center; margin-top: 24px; }
@media (max-width: 980px) { .release-grid { grid-template-columns: 1fr; } }
</style>
