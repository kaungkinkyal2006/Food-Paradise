package com.foodparadise.web;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;

import com.foodparadise.dao.PreOrderDao;
import com.foodparadise.model.PreOrderCartItem;
import com.foodparadise.model.PreOrderItem;
import com.foodparadise.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddPreOrderServlet")
public class AddPreOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1️⃣ Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2️⃣ Get preorder cart
        List<PreOrderCartItem> preorderCart = (List<PreOrderCartItem>) request.getSession().getAttribute("preorderCart");
        if (preorderCart == null || preorderCart.isEmpty()) {
            request.getSession().setAttribute("error", "Preorder cart is empty!");
            response.sendRedirect("preorder.jsp");
            return;
        }

        // 3️⃣ Get expected delivery date
        String expectedDateStr = request.getParameter("expectedDate");
        Date expectedDate;
        try {
            expectedDate = Date.valueOf(expectedDateStr); // yyyy-MM-dd -> java.sql.Date
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Invalid expected date!");
            response.sendRedirect("preorder.jsp");
            return;
        }

        // 4️⃣ Get delivery fee from form
        double deliveryFee = 0;
        String deliveryFeeStr = request.getParameter("deliveryFee");
        try {
            if (deliveryFeeStr != null) deliveryFee = Double.parseDouble(deliveryFeeStr);
        } catch (NumberFormatException ignored) {}

        // 5️⃣ Convert PreOrderCartItem -> PreOrderItem and calculate totals
        List<PreOrderItem> orderItems = new ArrayList<>();
        double originalTotal = 0;
        for (PreOrderCartItem item : preorderCart) {
            originalTotal += item.getPrice() * item.getQuantity();
            orderItems.add(new PreOrderItem(0, 0, item.getId(), item.getQuantity(), item.getPrice()));
        }

        // 6️⃣ Get phone number
        String phone = request.getParameter("phone");
        if (phone == null || !phone.matches("\\+959\\d{7,9}")) {
            request.getSession().setAttribute("error", "Please provide a valid phone number (+959XXXXXXXXX)");
            response.sendRedirect("preorder.jsp");
            return;
        }

        // 7️⃣ Apply discounts
        double discountAmount = 0;
        double finalTotal = originalTotal;
        String discountReason = "";

        int month = LocalDate.now().getMonthValue();
        if (month == 12) {
            discountAmount += originalTotal * 0.10;
            discountReason += "December Discount (10%) ";
        }
        if (month >= 4 && month <= 10) {
            discountAmount += originalTotal * 0.20;
            discountReason += "Rainy Season Discount (20%) ";
        }

        finalTotal = originalTotal - discountAmount + deliveryFee;

        // 8️⃣ Create preorder in DB
        PreOrderDao dao = new PreOrderDao();
        boolean success = dao.createPreOrderWithDiscount(
                user.getId(), orderItems, originalTotal,
                discountAmount, discountReason.trim(), finalTotal, phone, deliveryFee, expectedDate
        );

        // 9️⃣ Handle result
        if (success) {
            request.getSession().removeAttribute("preorderCart"); // Clear cart
            request.getSession().setAttribute("success",
                    String.format("Preorder placed successfully! 🎉 Final total: MMK%.2f (Delivery Fee: MMK%.2f)", finalTotal, deliveryFee));
            response.sendRedirect("MyPreorderServlet");
        } else {
            request.getSession().setAttribute("error", "Failed to place preorder. Please try again.");
            response.sendRedirect("preorder.jsp");
        }
    }
}
