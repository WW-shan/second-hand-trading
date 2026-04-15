package com.second.hand.trading.server.utils;

import org.junit.jupiter.api.Test;

import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertTrue;

class OrderTaskTests {

    @Test
    void shouldConvertDelayUsingRequestedTimeUnit() {
        OrderTask task = new OrderTask();
        task.setTime(System.currentTimeMillis() + TimeUnit.MINUTES.toMillis(1));

        long delayMillis = task.getDelay(TimeUnit.MILLISECONDS);
        long delaySeconds = task.getDelay(TimeUnit.SECONDS);

        assertTrue(delayMillis > TimeUnit.SECONDS.toMillis(50));
        assertTrue(delaySeconds >= 50);
    }
}
