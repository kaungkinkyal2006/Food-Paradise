package com.foodparadise.model;

public class PreOrderItem {
    private int id;
    private int orderId;
    private int itemId;
    private int qty;
    private double price;

    public PreOrderItem(int id, int orderId, int itemId, int qty, double price){
        this.id = id;
        this.orderId = orderId;
        this.itemId = itemId;
        this.qty = qty;
        this.price = price;
    }

    // getters
    public int getItemId() { return itemId; }
    public int getQty() { return qty; }
    public double getPrice() { return price; }
}

