package com.second.hand.trading.server.utils;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PageUtilsTests {

    @Test
    void shouldUseDefaultsWhenPageParamsAreInvalid() {
        assertEquals(1, PageUtils.resolvePage(null));
        assertEquals(1, PageUtils.resolvePage(0));
        assertEquals(8, PageUtils.resolvePageSize(null));
        assertEquals(8, PageUtils.resolvePageSize(-1));
    }

    @Test
    void shouldKeepPositivePageParams() {
        assertEquals(3, PageUtils.resolvePage(3));
        assertEquals(16, PageUtils.resolvePageSize(16));
    }
}
