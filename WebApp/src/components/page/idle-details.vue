<template>
    <div class="details-page">
        <app-head></app-head>
        <app-body>
            <section class="details-shell">
                <div class="details-hero">
                    <article class="seller-card">
                        <div class="seller-card-top">
                            <el-image class="seller-avatar" :src="idleItemInfo.user.avatar" fit="cover"></el-image>
                            <div>
                                <div class="section-kicker">Seller Profile</div>
                                <h2>{{ idleItemInfo.user.nickname || 'Marketplace Seller' }}</h2>
                                <div class="seller-meta">Joined {{ sellerJoinDate }}</div>
                            </div>
                        </div>
                        <div class="seller-note">
                            {{ isMaster ? 'You are viewing your own listing. Keep the details sharp and the gallery clean.' : 'Talk directly with the seller, inspect the gallery, and move fast before the listing disappears.' }}
                        </div>
                    </article>

                    <article class="cta-card">
                        <div class="section-kicker">Listing Overview</div>
                        <div class="price-row">
                            <span>Ask Price</span>
                            <strong>${{ idleItemInfo.idlePrice }}</strong>
                        </div>
                        <div class="status-pill" :class="listingStatusTone">{{ listingStatusText }}</div>
                        <div class="cta-actions">
                            <el-button v-if="!isMaster && idleItemInfo.idleStatus === 1" type="danger" @click="buyButton(idleItemInfo)">Buy Now</el-button>
                            <el-button v-if="!isMaster && idleItemInfo.idleStatus === 1" type="primary" plain @click="favoriteButton(idleItemInfo)">{{ isFavorite ? 'Remove Favorite' : 'Favorite' }}</el-button>
                            <el-button v-if="isMaster && idleItemInfo.idleStatus === 1" type="danger" plain @click="changeStatus(idleItemInfo, 2)">Remove Listing</el-button>
                            <el-button v-if="isMaster && idleItemInfo.idleStatus === 2" type="primary" plain @click="changeStatus(idleItemInfo, 1)">Relist</el-button>
                        </div>
                        <div v-if="!isMaster && idleItemInfo.idleStatus !== 1" class="status-note">This listing is currently offline or has been removed.</div>
                    </article>
                </div>

                <article class="details-card">
                    <div class="detail-tags">
                        <span class="detail-tag accent">{{ categoryLabel }}</span>
                        <span class="detail-tag">{{ idleItemInfo.idlePlace || 'Marketplace' }}</span>
                    </div>
                    <h1>{{ idleItemInfo.idleName }}</h1>
                    <div class="details-copy" v-html="idleItemInfo.idleDetails"></div>

                    <div v-if="idleItemInfo.pictureList.length" class="gallery-grid">
                        <div v-for="(imgUrl, i) in idleItemInfo.pictureList" :key="`img-${i}`" class="gallery-card">
                            <el-image :src="imgUrl" fit="cover" :preview-src-list="idleItemInfo.pictureList"></el-image>
                        </div>
                    </div>
                </article>

                <section class="conversation-card" id="replyMessageLocation">
                    <div class="conversation-head">
                        <div>
                            <div class="section-kicker">Conversation</div>
                            <h2>Questions, offers, and replies</h2>
                        </div>
                        <div class="conversation-count">{{ messageList.length }} messages</div>
                    </div>

                    <div class="message-send-card">
                        <div v-if="isReply" class="reply-banner">
                            <el-button class="reply-chip" type="info" plain @click="cancelReply">
                                Replying to {{ replyData.toUserNickname }} - {{ replyData.toMessage }}
                                <i class="el-icon-close el-icon--right"></i>
                            </el-button>
                        </div>
                        <el-input
                            type="textarea"
                            autosize
                            placeholder="Ask about condition, shipping speed, accessories, or payment timing..."
                            v-model="messageContent"
                            maxlength="200"
                            show-word-limit>
                        </el-input>
                        <div class="message-send-button">
                            <el-button type="primary" @click="sendMessage">Send Message</el-button>
                        </div>
                    </div>

                    <div v-if="!messageList.length" class="message-empty">No messages yet. Start the conversation and set the tone for the deal.</div>

                    <div v-for="(mes, index) in messageList" :key="`msg-${mes.id}-${index}`" class="message-card">
                        <div class="message-main">
                            <el-image class="message-avatar" :src="mes.fromU.avatar" fit="cover"></el-image>
                            <div class="message-copy">
                                <div class="message-topline">
                                    <div class="message-author">{{ mes.fromU.nickname }}</div>
                                    <div v-if="replyPreview(mes)" class="message-reply-target">{{ replyPreview(mes) }}</div>
                                </div>
                                <div class="message-content" v-html="mes.content"></div>
                                <div class="message-time">{{ mes.createTime }}</div>
                            </div>
                        </div>
                        <div class="message-actions">
                            <el-button plain @click="replyMessage(index)">Reply</el-button>
                        </div>
                    </div>
                </section>
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
    name: 'idle-details',
    components: {
        AppHead,
        AppBody,
        AppFoot
    },
    data() {
        return {
            messageContent: '',
            toUser: null,
            toMessage: null,
            isReply: false,
            replyData: {
                toUserNickname: '',
                toMessage: ''
            },
            messageList: [],
            idleItemInfo: {
                id: '',
                idleName: '',
                idleDetails: '',
                pictureList: [],
                idlePrice: 0,
                idlePlace: '',
                idleLabel: '',
                idleStatus: -1,
                userId: '',
                user: {
                    avatar: '',
                    nickname: '',
                    signInTime: ''
                }
            },
            isMaster: false,
            isFavorite: true,
            favoriteId: 0
        };
    },
    computed: {
        categoryLabel() {
            return {
                1: 'Digital',
                2: 'Appliances',
                3: 'Outdoor',
                4: 'Books',
                5: 'Other'
            }[this.idleItemInfo.idleLabel] || 'Curated Item';
        },
        listingStatusText() {
            if (this.idleItemInfo.idleStatus === 1) {
                return this.isMaster ? 'Your listing is live' : 'Available for checkout';
            }
            return 'Unavailable right now';
        },
        listingStatusTone() {
            return this.idleItemInfo.idleStatus === 1 ? 'is-live' : 'is-offline';
        },
        sellerJoinDate() {
            const signInTime = this.idleItemInfo.user && this.idleItemInfo.user.signInTime;
            return signInTime ? signInTime.substring(0, 10) : '--';
        }
    },
    created() {
        const id = this.$route.query.id;
        this.$api.getIdleItem({ id }).then(res => {
            if (res.data) {
                const list = res.data.idleDetails.split(/\r?\n/);
                let str = '';
                for (let i = 0; i < list.length; i++) {
                    str += '<p>' + list[i] + '</p>';
                }
                res.data.idleDetails = str;
                res.data.pictureList = JSON.parse(res.data.pictureList);
                this.idleItemInfo = res.data;
                const userId = this.getCookie('shUserId');
                if (userId == this.idleItemInfo.userId) {
                    this.isMaster = true;
                }
                this.checkFavorite();
                this.getAllIdleMessage();
            }
            this.scrollToPosition(0);
        });
    },
    methods: {
        scrollToPosition(top) {
            window.scrollTo({
                top,
                behavior: 'smooth'
            });
        },
        replyPreview(message) {
            if (!message.toU || !message.toU.nickname || !message.toM || !message.toM.content) {
                return '';
            }
            const snippet = message.toM.content.substring(0, 10) + (message.toM.content.length > 10 ? '...' : '');
            return 'Reply to ' + message.toU.nickname + ': ' + snippet;
        },
        getAllIdleMessage() {
            this.$api.getAllIdleMessage({
                idleId: this.idleItemInfo.id
            }).then(res => {
                if (res.status_code === 1) {
                    this.messageList = res.data;
                }
            }).catch(() => {
            });
        },
        checkFavorite() {
            this.$api.checkFavorite({
                idleId: this.idleItemInfo.id
            }).then(res => {
                if (!res.data) {
                    this.isFavorite = false;
                } else {
                    this.favoriteId = res.data;
                }
            });
        },
        getCookie(cname) {
            var name = cname + '=';
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i].trim();
                if (c.indexOf(name) === 0) return c.substring(name.length, c.length);
            }
            return '';
        },
        replyMessage(index) {
            const replyTarget = document.getElementById('replyMessageLocation');
            if (replyTarget) {
                const targetTop = replyTarget.getBoundingClientRect().top + window.scrollY - 220;
                this.scrollToPosition(targetTop);
            }
            this.isReply = true;
            this.replyData.toUserNickname = this.messageList[index].fromU.nickname;
            this.replyData.toMessage = this.messageList[index].content.substring(0, 10) + (this.messageList[index].content.length > 10 ? '...' : '');
            this.toUser = this.messageList[index].userId;
            this.toMessage = this.messageList[index].id;
        },
        changeStatus(idle, status) {
            this.$api.updateIdleItem({
                id: idle.id,
                idleStatus: status
            }).then(res => {
                if (res.status_code === 1) {
                    this.idleItemInfo.idleStatus = status;
                } else {
                    this.$message.error(res.msg);
                }
            });
        },
        buyButton(idleItemInfo) {
            this.$api.addOrder({
                idleId: idleItemInfo.id,
                orderPrice: idleItemInfo.idlePrice
            }).then(res => {
                if (res.status_code === 1) {
                    this.$router.push({ path: '/order', query: { id: res.data.id } });
                } else {
                    this.$message.error(res.msg);
                }
            }).catch(() => {
            });
        },
        favoriteButton(idleItemInfo) {
            if (this.isFavorite) {
                this.$api.deleteFavorite({
                    id: this.favoriteId
                }).then(res => {
                    if (res.status_code === 1) {
                        this.$message({
                            message: 'Removed from favorites!',
                            type: 'success'
                        });
                        this.isFavorite = false;
                    } else {
                        this.$message.error(res.msg);
                    }
                }).catch(() => {
                });
            } else {
                this.$api.addFavorite({
                    idleId: idleItemInfo.id
                }).then(res => {
                    if (res.status_code === 1) {
                        this.$message({
                            message: 'Added to favorites!',
                            type: 'success'
                        });
                        this.isFavorite = true;
                        this.favoriteId = res.data;
                    } else {
                        this.$message.error(res.msg);
                    }
                }).catch(() => {
                });
            }
        },
        cancelReply() {
            this.isReply = false;
            this.toUser = this.idleItemInfo.userId;
            this.toMessage = null;
            this.replyData.toUserNickname = '';
            this.replyData.toMessage = '';
        },
        sendMessage() {
            let content = this.messageContent.trim();
            if (this.toUser == null) {
                this.toUser = this.idleItemInfo.userId;
            }
            if (content) {
                let contentList = content.split(/\r?\n/);
                let contenHtml = contentList[0];
                for (let i = 1; i < contentList.length; i++) {
                    contenHtml += '<br>' + contentList[i];
                }
                this.$api.sendMessage({
                    idleId: this.idleItemInfo.id,
                    content: contenHtml,
                    toUser: this.toUser,
                    toMessage: this.toMessage
                }).then(res => {
                    if (res.status_code === 1) {
                        this.$message({
                            message: 'Message sent successfully!',
                            type: 'success'
                        });
                        this.messageContent = '';
                        this.cancelReply();
                        this.getAllIdleMessage();
                    } else {
                        this.$message.error('Failed to send message! ' + res.msg);
                    }
                }).catch(() => {
                    this.$message.error('Failed to send message!');
                });
            } else {
                this.$message.error('Message cannot be empty!');
            }
        }
    }
};
</script>

<style scoped>
.details-shell {
    display: grid;
    gap: 24px;
}

.details-hero,
.details-card,
.conversation-card {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}

.details-hero {
    display: grid;
    grid-template-columns: 1.1fr 0.9fr;
    gap: 24px;
}

.seller-card,
.cta-card {
    padding: 30px;
}

.seller-card {
    background: radial-gradient(circle at top left, rgba(0, 221, 255, 0.16), transparent 30%), rgba(255, 255, 255, 0.02);
}

.seller-card-top {
    display: flex;
    align-items: center;
    gap: 18px;
}

.seller-avatar {
    width: 90px;
    height: 90px;
    border-radius: 26px;
    overflow: hidden;
    flex-shrink: 0;
}

.section-kicker {
    font-size: 12px;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--accent);
}

.seller-card h2,
.conversation-head h2 {
    margin: 12px 0 8px;
    font-size: 30px;
    line-height: 1.04;
}

.seller-meta,
.seller-note,
.status-note,
.conversation-count,
.message-empty,
.message-time,
.details-copy :deep(p) {
    color: var(--text-soft);
}

.seller-note {
    margin-top: 22px;
    line-height: 1.8;
    max-width: 580px;
}

.cta-card {
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 16px;
    background: radial-gradient(circle at bottom right, rgba(124, 255, 107, 0.12), transparent 34%), rgba(255, 255, 255, 0.02);
}

.price-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 20px;
}

.price-row span {
    color: rgba(255, 255, 255, 0.56);
    text-transform: uppercase;
    letter-spacing: 0.12em;
    font-size: 12px;
}

.price-row strong {
    font-size: 42px;
    line-height: 1;
}

.status-pill {
    width: fit-content;
    padding: 10px 16px;
    border-radius: 999px;
    font-weight: 800;
    letter-spacing: 0.04em;
}

.status-pill.is-live {
    background: rgba(124, 255, 107, 0.12);
    color: #dbffd5;
    border: 1px solid rgba(124, 255, 107, 0.2);
}

.status-pill.is-offline {
    background: rgba(255, 93, 143, 0.12);
    color: #ffd4e2;
    border: 1px solid rgba(255, 93, 143, 0.2);
}

.cta-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
}

.details-card {
    padding: 34px;
}

.detail-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-bottom: 18px;
}

.detail-tag {
    padding: 9px 14px;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.06);
    font-size: 12px;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: rgba(255, 255, 255, 0.74);
}

.detail-tag.accent {
    color: #dffbff;
    background: rgba(0, 221, 255, 0.12);
    border-color: rgba(0, 221, 255, 0.22);
}

.details-card h1 {
    margin: 0 0 20px;
    font-size: 46px;
    line-height: 0.98;
    letter-spacing: -0.04em;
}

.details-copy {
    font-size: 16px;
    line-height: 1.85;
}

.details-copy :deep(p) {
    margin: 0 0 14px;
}

.gallery-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 18px;
    margin-top: 28px;
}

.gallery-card {
    min-height: 260px;
    border-radius: 24px;
    overflow: hidden;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.06);
}

.gallery-card :deep(.el-image) {
    width: 100%;
    height: 100%;
    display: block;
}

.conversation-card {
    padding: 30px;
}

.conversation-head {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    gap: 20px;
    margin-bottom: 20px;
}

.conversation-count {
    padding: 12px 16px;
    border-radius: 16px;
    background: rgba(255, 255, 255, 0.04);
    border: 1px solid rgba(255, 255, 255, 0.06);
    font-weight: 700;
}

.message-send-card {
    padding: 20px;
    border-radius: 22px;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.06);
}

.reply-banner {
    margin-bottom: 14px;
}

.reply-chip {
    max-width: 100%;
}

.message-send-button {
    margin-top: 14px;
    display: flex;
    justify-content: flex-end;
}

.message-empty {
    padding: 28px 0 8px;
    text-align: center;
}

.message-card {
    display: flex;
    justify-content: space-between;
    gap: 18px;
    padding: 20px 0;
    border-top: 1px solid rgba(255, 255, 255, 0.06);
}

.message-main {
    display: flex;
    gap: 14px;
    min-width: 0;
    flex: 1;
}

.message-avatar {
    width: 58px;
    height: 58px;
    border-radius: 18px;
    overflow: hidden;
    flex-shrink: 0;
}

.message-copy {
    min-width: 0;
    flex: 1;
}

.message-topline {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
    margin-bottom: 8px;
}

.message-author {
    font-size: 18px;
    font-weight: 800;
}

.message-reply-target {
    font-size: 12px;
    padding: 6px 10px;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.05);
    color: rgba(255, 255, 255, 0.7);
}

.message-content {
    line-height: 1.8;
    color: rgba(255, 255, 255, 0.84);
    word-break: break-word;
}

.message-actions {
    flex-shrink: 0;
    display: flex;
    align-items: flex-start;
}

@media (max-width: 980px) {
    .details-hero,
    .gallery-grid {
        grid-template-columns: 1fr;
    }

    .details-card,
    .conversation-card,
    .seller-card,
    .cta-card {
        padding: 24px;
    }

    .details-card h1 {
        font-size: 34px;
    }

    .conversation-head,
    .message-card {
        flex-direction: column;
        align-items: flex-start;
    }

    .message-actions {
        width: 100%;
    }
}
</style>
