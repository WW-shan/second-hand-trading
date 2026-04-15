<template>
    <div class="main-container">
        <div class="main-content">
            <slot></slot>
        </div>
    </div>
</template>

<script>
export default {
    name: 'PageBody'
}
</script>

<style scoped>
.main-container {
    margin-top: 92px;
    display: flex;
    justify-content: center;
    padding: 0 18px 48px;
}

.main-content {
    width: min(var(--content-width), calc(100vw - 36px));
    min-height: calc(100vh - 120px);
    background: transparent;
}

@media (max-width: 1120px) {
    .main-container {
        margin-top: 132px;
    }
}

@media (max-width: 720px) {
    .main-container {
        margin-top: 192px;
        padding: 0 12px 40px;
    }

    .main-content {
        width: calc(100vw - 24px);
    }
}
</style>
