package com.foodparadise.model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private int id;
    private String name;
    private double price;
    private int quantity;

    public CartItem(int id, String name, double price, int quantity){
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    // Getters and setters
    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
