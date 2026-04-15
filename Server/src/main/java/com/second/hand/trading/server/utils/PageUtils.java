package com.second.hand.trading.server.utils;

/**
 * Simple pagination parameter normalization for controllers.
 */
public final class PageUtils {

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_PAGE_SIZE = 8;

    private PageUtils() {
    }

    public static int resolvePage(Integer page) {
        return resolvePositiveOrDefault(page, DEFAULT_PAGE);
    }

    public static int resolvePageSize(Integer pageSize) {
        return resolvePositiveOrDefault(pageSize, DEFAULT_PAGE_SIZE);
    }

    public static int resolvePositiveOrDefault(Integer value, int defaultValue) {
        return value != null && value > 0 ? value : defaultValue;
    }
}
