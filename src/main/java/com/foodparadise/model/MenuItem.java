package com.foodparadise.model;

public class MenuItem {
    private int id;
    private int categoryId;
    private String name;
    private double price;
    private String imgUrl;
    private String description;
    private int stock; // new field for admin stock management

    // Constructor with stock
    public MenuItem(int id, int categoryId, String name, double price, String imgUrl, String description, int stock) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.price = price;
        this.imgUrl = imgUrl;
        this.description = description;
        this.stock = stock;
    }

    // Optional: Default constructor
    public MenuItem() {}

    // Getters
    public int getId() { return id; }
    public int getCategoryId() { return categoryId; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getImgUrl() { return imgUrl; }
    public String getDescription() { return description; }
    public int getStock() { return stock; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public void setName(String name) { this.name = name; }
    public void setPrice(double price) { this.price = price; }
    public void setImgUrl(String imgUrl) { this.imgUrl = imgUrl; }
    public void setDescription(String description) { this.description = description; }
    public void setStock(int stock) { this.stock = stock; }
}
