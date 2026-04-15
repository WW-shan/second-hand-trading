<template>
    <div id="app">
        <router-view></router-view>
    </div>
</template>
<style>
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Rajdhani:wght@600;700&display=swap');

:root {
    --bg: #050816;
    --bg-soft: #0b1020;
    --panel: rgba(12, 18, 36, 0.82);
    --panel-strong: rgba(16, 24, 49, 0.94);
    --panel-border: rgba(99, 116, 255, 0.18);
    --text: #f5f7ff;
    --text-soft: #98a3c7;
    --accent: #00ddff;
    --accent-2: #7cff6b;
    --danger: #ff5d8f;
    --shadow: 0 20px 80px rgba(0, 0, 0, 0.38);
    --radius-xl: 28px;
    --radius-lg: 20px;
    --radius-md: 16px;
    --content-width: 1240px;
}

* {
    box-sizing: border-box;
}

html,
body,
#app {
    min-height: 100%;
    overflow-x: hidden;
}

html,
body {
    margin: 0;
    background:
        radial-gradient(circle at top left, rgba(0, 221, 255, 0.18), transparent 26%),
        radial-gradient(circle at 85% 15%, rgba(124, 255, 107, 0.12), transparent 24%),
        linear-gradient(135deg, #040613 0%, #090d1d 46%, #060918 100%);
    color: var(--text);
    font-family: 'Manrope', 'Segoe UI', sans-serif;
}

body::before,
body::after {
    content: '';
    position: fixed;
    inset: auto;
    z-index: 0;
    pointer-events: none;
    filter: blur(80px);
    opacity: 0.5;
}

body::before {
    top: -120px;
    right: 8%;
    width: 320px;
    height: 320px;
    background: rgba(0, 221, 255, 0.18);
}

body::after {
    bottom: -120px;
    left: 6%;
    width: 360px;
    height: 360px;
    background: rgba(124, 255, 107, 0.16);
}

#app {
    position: relative;
    z-index: 1;
}

a {
    color: inherit;
}

::selection {
    background: rgba(0, 221, 255, 0.28);
    color: #fff;
}

.el-loading-mask {
    background-color: rgba(5, 8, 22, 0.72) !important;
    backdrop-filter: blur(8px);
}

.el-card,
.el-dialog,
.el-table,
.el-menu,
.el-tabs--card > .el-tabs__header .el-tabs__nav {
    border: 1px solid rgba(255, 255, 255, 0.06);
}

.el-card,
.el-dialog {
    background: var(--panel-strong) !important;
    box-shadow: var(--shadow) !important;
    border-radius: var(--radius-lg) !important;
}

.el-dialog__title,
.el-form-item__label,
.el-checkbox__label,
.el-page-header__content,
.el-table th,
.el-table td,
.el-tabs__item,
.el-pagination,
.el-dropdown-menu__item,
.el-input__inner,
.el-textarea__inner {
    color: var(--text) !important;
}

.el-dialog__header,
.el-dialog__body,
.el-dialog__footer {
    background: transparent !important;
}

.el-input__inner,
.el-textarea__inner,
.el-input-group__append,
.el-input-group__prepend {
    background: rgba(9, 15, 31, 0.88) !important;
    border-color: rgba(255, 255, 255, 0.08) !important;
    color: var(--text) !important;
    border-radius: 14px !important;
}

.el-input-group__append,
.el-input-group__prepend {
    color: var(--text-soft) !important;
}

.el-input__inner::placeholder,
.el-textarea__inner::placeholder {
    color: rgba(183, 194, 233, 0.55) !important;
}

.el-button {
    border-radius: 14px !important;
    font-weight: 700 !important;
    letter-spacing: 0.02em;
}

.el-button--primary {
    background: linear-gradient(135deg, var(--accent), #5a8bff) !important;
    border: none !important;
    box-shadow: 0 14px 30px rgba(0, 157, 255, 0.3) !important;
}

.el-button--primary.is-plain,
.el-button--default,
.el-button--info.is-plain,
.el-button--danger.is-plain {
    background: rgba(12, 18, 36, 0.8) !important;
    color: var(--text) !important;
    border-color: rgba(255, 255, 255, 0.1) !important;
}

.el-button--danger {
    background: linear-gradient(135deg, #ff5d8f, #ff7a5d) !important;
    border: none !important;
}

.el-tabs--card > .el-tabs__header {
    border-bottom: none !important;
    margin-bottom: 18px;
}

.el-tabs--card > .el-tabs__header .el-tabs__item {
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    border-radius: 999px !important;
    margin-right: 10px;
    background: rgba(10, 14, 30, 0.72);
    height: 42px;
    line-height: 40px;
    padding: 0 18px;
    transition: all 0.25s ease;
}

.el-tabs--card > .el-tabs__header .el-tabs__item.is-active {
    background: rgba(0, 221, 255, 0.14);
    color: #fff !important;
    box-shadow: inset 0 0 0 1px rgba(0, 221, 255, 0.2);
}

.el-tabs--card > .el-tabs__header .el-tabs__nav {
    background: transparent !important;
    border: none !important;
}

.el-table,
.el-table tr,
.el-table th,
.el-table td,
.el-table__expanded-cell {
    background: transparent !important;
}

.el-table {
    color: var(--text) !important;
    border-radius: var(--radius-lg);
    overflow: hidden;
}

.el-table th {
    background: rgba(255, 255, 255, 0.03) !important;
    font-weight: 700;
}

.el-table::before {
    background-color: rgba(255, 255, 255, 0.06) !important;
}

.el-table td,
.el-table th.is-leaf {
    border-bottom-color: rgba(255, 255, 255, 0.06) !important;
}

.el-table tbody tr:hover > td {
    background: rgba(255, 255, 255, 0.035) !important;
}

.el-pagination button,
.el-pager li {
    background: rgba(12, 18, 36, 0.84) !important;
    color: var(--text) !important;
    border-radius: 12px;
}

.el-pager li.active {
    background: rgba(0, 221, 255, 0.16) !important;
    color: #fff !important;
}

.el-dropdown-menu {
    background: rgba(10, 14, 30, 0.96) !important;
    border: 1px solid rgba(255, 255, 255, 0.08) !important;
    border-radius: 16px !important;
    padding: 8px !important;
}

.el-dropdown-menu__item:hover,
.el-dropdown-menu__item:focus {
    background: rgba(255, 255, 255, 0.06) !important;
}

.el-menu {
    background: rgba(10, 14, 30, 0.88) !important;
}

.el-menu-item,
.el-submenu__title {
    color: var(--text-soft) !important;
}

.el-menu-item.is-active,
.el-menu-item:hover,
.el-submenu__title:hover {
    color: #fff !important;
    background: rgba(255, 255, 255, 0.05) !important;
}

.el-empty__description,
.el-form-item__error,
.el-upload__text,
.el-upload-dragger .el-upload__text {
    color: var(--text-soft) !important;
}

.el-cascader,
.el-input-number {
    max-width: 100%;
}

@media (max-width: 980px) {
    .el-dialog {
        width: min(92vw, 560px) !important;
    }

    .el-tabs__nav-wrap {
        overflow-x: auto !important;
        scrollbar-width: none;
    }

    .el-tabs__nav-wrap::-webkit-scrollbar {
        display: none;
    }

    .el-tabs__nav {
        display: inline-flex !important;
        float: none !important;
        white-space: nowrap;
    }
}
</style>
