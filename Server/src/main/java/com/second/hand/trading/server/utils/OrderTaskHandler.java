package com.second.hand.trading.server.utils;

import com.second.hand.trading.server.service.OrderService;

import java.util.concurrent.DelayQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Handles delayed order timeout tasks without busy-spinning.
 */
public class OrderTaskHandler {

    private static final AtomicBoolean STARTED = new AtomicBoolean(false);
    private static final DelayQueue<OrderTask> DELAY_QUEUE = new DelayQueue<>();

    private static volatile OrderService orderService;

    private OrderTaskHandler() {
    }

    public static void setOrderService(OrderService orderService) {
        OrderTaskHandler.orderService = orderService;
    }

    public static void run() {
        if (!STARTED.compareAndSet(false, true)) {
            return;
        }

        Thread worker = new Thread(() -> {
            System.out.println("OrderTaskHandler run!");
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    if (orderService == null) {
                        TimeUnit.MILLISECONDS.sleep(200);
                        continue;
                    }
                    OrderTask orderTask = DELAY_QUEUE.take();
                    if (orderService.updateOrder(orderTask.getOrderModel())) {
                        System.out.println("Order canceled by timeout: " + orderTask.getOrderModel());
                    } else {
                        System.out.println("Order timeout task skipped: " + orderTask.getOrderModel());
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } catch (Exception e) {
                    System.err.println("OrderTaskHandler process error: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }, "order-timeout-handler");
        worker.setDaemon(true);
        worker.start();
    }

    public static void addOrder(OrderTask orderTask) {
        System.out.println("Add order timeout task: " + orderTask);
        DELAY_QUEUE.put(orderTask);
    }
}
