<template>
    <div class="foot-container">
        <div class="author">AIEN Second-hand Trading Platform</div>
        <div class="foot-note">Curated resale for digital-native collectors.</div>
    </div>
</template>

<script>
export default {
    name: 'Foot'
}
</script>

<style scoped>
.foot-container {
    width: min(var(--content-width), calc(100vw - 36px));
    margin: 28px auto 0;
    padding: 22px 0 12px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
}

.author {
    color: var(--text);
    font-weight: 700;
    letter-spacing: 0.06em;
    text-transform: uppercase;
}

.foot-note {
    color: var(--text-soft);
    font-size: 13px;
}
</style>
