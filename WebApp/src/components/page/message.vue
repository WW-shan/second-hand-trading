<template>
    <div class="message-page">
        <app-head></app-head>
        <app-body>
            <section class="message-hero">
                <div>
                    <div class="page-kicker">Inbox Control</div>
                    <h1>Keep every negotiation in one clean thread.</h1>
                    <p>Review new buyer questions, jump back to the item page, and keep the resale flow moving without clutter.</p>
                </div>
                <div class="message-count">{{ meslist.length }} conversations</div>
            </section>

            <section class="message-shell">
                <div v-if="meslist.length === 0" class="empty-state">No messages yet. Once buyers start reaching out, every thread will appear here.</div>

                <article v-for="mes in meslist" :key="mes.id" class="message-card" @click="toDetails(mes.idle.id)">
                    <div class="message-main">
                        <el-image class="message-avatar" :src="mes.fromU.avatar" fit="cover"></el-image>
                        <div class="message-copy">
                            <div class="message-topline">
                                <div>
                                    <div class="message-author">{{ mes.fromU.nickname }}</div>
                                    <div class="message-time">{{ mes.displayTime }}</div>
                                </div>
                                <div class="message-chip">Item Inquiry</div>
                            </div>
                            <div class="message-preview">{{ mes.contentPreview }}</div>
                        </div>
                    </div>
                    <div class="message-item-card">
                        <el-image class="message-item-image" :src="mes.idle.imgUrl" fit="cover"></el-image>
                        <div class="message-item-copy">
                            <div class="message-item-title">{{ mes.idle.idleName || 'Listing' }}</div>
                            <div class="message-item-link">Open item details</div>
                        </div>
                    </div>
                </article>
            </section>
            <app-foot></app-foot>
        </app-body>
    </div>
</template>
<script>
import AppHead from '../common/AppHeader.vue';
import AppBody from '../common/AppPageBody.vue';
import AppFoot from '../common/AppFoot.vue';
import { firstPicture, formatDateTime } from '../../utils/idle';

export default {
    name: 'message',
    components: { AppHead, AppBody, AppFoot },
    data() {
        return { meslist: [] };
    },
    created() {
        this.$api.getAllMyMessage().then(res => {
            if (res.status_code === 1) {
                this.meslist = res.data.map(item => {
                    const preview = item.content.split('<br>').join(' ').trim();
                    return {
                        ...item,
                        contentPreview: preview,
                        displayTime: formatDateTime(item.createTime),
                        idle: {
                            ...item.idle,
                            imgUrl: firstPicture(item.idle.pictureList)
                        }
                    };
                });
            }
        });
    },
    methods: {
        toDetails(id) { this.$router.push({ path: '/details', query: { id } }); }
    }
};
</script>
<style scoped>
.message-page { color: var(--text); }
.message-hero,
.message-shell {
    border-radius: var(--radius-xl);
    background: var(--panel);
    border: 1px solid var(--panel-border);
    box-shadow: var(--shadow);
}
.message-hero {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    padding: 30px 32px;
    margin-bottom: 24px;
}
.page-kicker {
    font-size: 12px;
    letter-spacing: 0.18em;
    text-transform: uppercase;
    color: var(--accent);
}
.message-hero h1 { margin: 14px 0 10px; font-size: 38px; }
.message-hero p { margin: 0; color: var(--text-soft); line-height: 1.7; max-width: 760px; }
.message-count {
    padding: 16px 18px;
    border-radius: 18px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.08);
    font-weight: 800;
    white-space: nowrap;
}
.message-shell { padding: 24px 28px; }
.empty-state {
    padding: 42px 10px;
    text-align: center;
    color: var(--text-soft);
}
.message-card {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 280px;
    gap: 18px;
    padding: 18px 0;
    cursor: pointer;
    border-top: 1px solid rgba(255,255,255,0.06);
    transition: transform .24s ease;
}
.message-card:first-of-type { border-top: none; }
.message-card:hover { transform: translateY(-3px); }
.message-main {
    display: flex;
    gap: 14px;
    min-width: 0;
}
.message-avatar {
    width: 60px;
    height: 60px;
    border-radius: 18px;
    overflow: hidden;
    flex-shrink: 0;
}
.message-copy { min-width: 0; flex: 1; }
.message-topline {
    display: flex;
    justify-content: space-between;
    gap: 16px;
    align-items: flex-start;
    margin-bottom: 10px;
}
.message-author { font-size: 18px; font-weight: 800; }
.message-time { margin-top: 6px; color: var(--text-soft); font-size: 13px; }
.message-chip {
    padding: 8px 12px;
    border-radius: 999px;
    background: rgba(0,221,255,0.1);
    border: 1px solid rgba(0,221,255,0.16);
    font-size: 12px;
    font-weight: 700;
    color: #dffbff;
    white-space: nowrap;
}
.message-preview {
    color: rgba(255,255,255,0.82);
    line-height: 1.8;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}
.message-item-card {
    display: flex;
    gap: 12px;
    align-items: center;
    padding: 14px;
    border-radius: 18px;
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.06);
}
.message-item-image {
    width: 92px;
    height: 92px;
    border-radius: 16px;
    overflow: hidden;
    flex-shrink: 0;
}
.message-item-copy { min-width: 0; }
.message-item-title {
    font-size: 16px;
    font-weight: 800;
    margin-bottom: 8px;
    line-height: 1.3;
}
.message-item-link {
    color: var(--accent);
    font-size: 13px;
}
@media (max-width: 980px) {
    .message-hero {
        flex-direction: column;
        align-items: flex-start;
    }

    .message-card {
        grid-template-columns: 1fr;
    }

    .message-topline {
        flex-direction: column;
        align-items: flex-start;
    }
}
</style>
