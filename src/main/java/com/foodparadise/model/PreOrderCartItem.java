package com.foodparadise.model;

import java.io.Serializable;
import java.util.Date;


public class PreOrderCartItem implements Serializable {
    private int id;
    private String name;
    private double price;
    private int quantity;
    // private Date expectedDeliveryDate;


    public PreOrderCartItem(int id, String name, double price, int quantity){
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
    // public Date getExpectedDeliveryDate() { return expectedDeliveryDate; }
    //  public void setExpectedDeliveryDate(Date expectedDeliveryDate) { this.expectedDeliveryDate = expectedDeliveryDate; }
}
