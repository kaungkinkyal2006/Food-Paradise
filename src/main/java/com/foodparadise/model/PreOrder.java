package com.foodparadise.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;

public class PreOrder {
    private int id;
    private int userId;
    private String userName;
    private double total;
    private Double deliveryFee;
    private Date expectedDate;

    private String phone;

    private Timestamp createdAt;
    private double originalTotal; // Store original total before discount
    private double discountAmount; // Store discount amount
    private String discountReason; // Store reason for discount

    public PreOrder() {}

    public PreOrder(int id, int userId, double total, Double deliveryFee, Timestamp createdAt, Date expectedDate) {
        this.id = id;
        this.userId = userId;
        this.total = total;
        this.deliveryFee = deliveryFee;
        this.createdAt = createdAt;
        this.originalTotal = total;
        this.expectedDate = expectedDate;
        this.discountAmount = 0.0;
        this.discountReason = "";
    }

    // Method to calculate total with December discount
    public double calculateFinalTotal(double originalAmount) {
        LocalDate currentDate = LocalDate.now();

        // Check if current month is December (month 12)
        if (currentDate.getMonthValue() == 12) {
            this.originalTotal = originalAmount;
            this.discountAmount = originalAmount * 0.10; // 10% discount
            this.discountReason = "December Special Discount (10%)";
            this.total = originalAmount - this.discountAmount;
            return this.total;
        } else {
            this.originalTotal = originalAmount;
            this.discountAmount = 0.0;
            this.discountReason = "";
            this.total = originalAmount;
            return this.total;
        }
    }

    // Check if December discount is applicable
    public static boolean isDecemberDiscountApplicable() {
        LocalDate currentDate = LocalDate.now();
        return currentDate.getMonthValue() == 12;
    }

    // Get discount percentage for December
    public static double getDecemberDiscountPercentage() {
        return 0.10; // 10%
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Date getExpectedAt() { return expectedDate; }
    public void setExpectedAt(Date expectedDate) { this.expectedDate = expectedDate; }

    public double getOriginalTotal() { return originalTotal; }
    public void setOriginalTotal(double originalTotal) { this.originalTotal = originalTotal; }

    public double getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(double discountAmount) { this.discountAmount = discountAmount; }

    public String getDiscountReason() { return discountReason; }
    public void setDiscountReason(String discountReason) { this.discountReason = discountReason; }

    public String getPhone() { return phone; }
public void setPhone(String phone) { this.phone = phone; }

public Double getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(Double deliveryFee) { this.deliveryFee = deliveryFee; }

    public String getUserName() {
    return userName;
}

public void setUserName(String userName) {
    this.userName = userName;
}


}