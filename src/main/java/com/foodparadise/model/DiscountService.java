package com.foodparadise.model;

import com.foodparadise.model.Order;
import java.time.LocalDate;

public class DiscountService {

    /**
     * Calculate the final total with applicable discounts
     * @param originalTotal The original total amount
     * @return Order object with discount information applied
     */
    public static Order calculateOrderTotal(double originalTotal) {
        Order order = new Order();

        LocalDate currentDate = LocalDate.now();

        // Check if it's December (month 12)
        if (currentDate.getMonthValue() == 12) {
            // Apply 10% December discount
            double discountAmount = originalTotal * 0.10;
            double finalTotal = originalTotal - discountAmount;

            order.setOriginalTotal(originalTotal);
            order.setDiscountAmount(discountAmount);
            order.setDiscountReason("December Special Discount (10%)");
            order.setTotal(finalTotal);
        } else {
            // No discount applicable
            order.setOriginalTotal(originalTotal);
            order.setDiscountAmount(0.0);
            order.setDiscountReason("");
            order.setTotal(originalTotal);
        }

        return order;
    }

    /**
     * Check if December discount is currently active
     * @return true if December discount is applicable
     */
    public static boolean isDecemberDiscountActive() {
        LocalDate currentDate = LocalDate.now();
        return currentDate.getMonthValue() == 12;
    }

    /**
     * Get the current discount percentage for December
     * @return discount percentage as decimal (0.10 for 10%)
     */
    public static double getDecemberDiscountPercentage() {
        return 0.10; // 10% discount
    }

    /**
     * Format discount information for display
     * @param originalTotal Original amount before discount
     * @param discountAmount Amount discounted
     * @param finalTotal Final amount after discount
     * @return formatted discount information string
     */
    public static String formatDiscountInfo(double originalTotal, double discountAmount, double finalTotal) {
        if (discountAmount > 0) {
            return String.format("Original: MMK%.2f, Discount: -MMK%.2f (10%%), Final: MMK%.2f",
                    originalTotal, discountAmount, finalTotal);
        } else {
            return String.format("Total: MMK%.2f", finalTotal);
        }
    }
}