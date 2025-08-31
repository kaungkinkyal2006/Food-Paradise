package com.foodparadise.web;

import com.foodparadise.dao.OrderDAO;
import com.foodparadise.model.CartItem;
import com.foodparadise.model.OrderItem;
import com.foodparadise.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddOrderServlet")
public class AddOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if(user == null){
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the cart from session
        List<CartItem> cart = (List<CartItem>) request.getSession().getAttribute("cart");
        if(cart == null || cart.isEmpty()){
            request.getSession().setAttribute("error", "Cart is empty!");
            response.sendRedirect("cart.jsp");
            return;
        }

        // Get phone number from form
        String phone = request.getParameter("phone");
        if(phone == null || !phone.matches("\\+959\\d{7,9}")){
            request.getSession().setAttribute("error", "Please provide a valid phone number (+959XXXXXXXXX)");
            response.sendRedirect("cart.jsp");
            return;
        }

        // Update quantities from form submission
        for(int i = 0; i < cart.size(); i++){
            String qtyParam = request.getParameter("quantity_" + i);
            int quantity = 1;
            try {
                quantity = Integer.parseInt(qtyParam);
                if(quantity < 1) quantity = 1;
            } catch(NumberFormatException e){
                // fallback to 1 if invalid
                quantity = 1;
            }
            cart.get(i).setQuantity(quantity);
        }

        // Convert CartItem -> OrderItem and calculate original total
        List<OrderItem> orderItems = new ArrayList<>();
        double originalTotal = 0;
        for(CartItem item : cart){
            originalTotal += item.getPrice() * item.getQuantity();
            orderItems.add(new OrderItem(0, 0, item.getId(), item.getQuantity(), item.getPrice()));
        }

        // Apply December discount if applicable
        double discountAmount = 0;
        double finalTotal = originalTotal;
        String discountReason = "";
        boolean isDecemberDiscount = false;

        LocalDate currentDate = LocalDate.now();
        if(currentDate.getMonthValue() == 12) {
            // Apply 10% December discount
            discountAmount = originalTotal * 0.10;
            finalTotal = originalTotal - discountAmount;
            discountReason = "December Special Discount (10%)";
            isDecemberDiscount = true;

            System.out.println("December discount applied: Original=" + originalTotal +
                    ", Discount=" + discountAmount + ", Final=" + finalTotal);
        }

        // Save order to database with discount information
        OrderDAO dao = new OrderDAO();
        boolean success;

        try {
            // Try to create order with discount info
            success = dao.createOrderWithDiscount(user.getId(), orderItems, originalTotal,
                    discountAmount, discountReason, finalTotal, phone);
        } catch (Exception e) {
            // Fallback to original method if createOrderWithDiscount doesn't exist
            System.out.println("Using fallback createOrder method: " + e.getMessage());
            success = dao.createOrder(user.getId(), orderItems, finalTotal);
        }

        if(success){
            // Store order details in session for success page
            request.getSession().setAttribute("lastOrderOriginalTotal", originalTotal);
            request.getSession().setAttribute("lastOrderDiscountAmount", discountAmount);
            request.getSession().setAttribute("lastOrderFinalTotal", finalTotal);
            request.getSession().setAttribute("lastOrderDiscountReason", discountReason);
            request.getSession().setAttribute("lastOrderPhone", phone);
            request.getSession().setAttribute("isDecemberDiscount", isDecemberDiscount);

            // Clear cart after successful order
            request.getSession().removeAttribute("cart");

            // Set success message
            if(isDecemberDiscount) {
                request.getSession().setAttribute("success",
                        String.format("Order placed successfully! 🎄 You saved MMK%.2f with December discount! Final total: MMK%.2f",
                                discountAmount, finalTotal));
            } else {
                request.getSession().setAttribute("success",
                        String.format("Order placed successfully! Total: MMK%.2f", finalTotal));
            }

            // Redirect to My Orders page
            response.sendRedirect("MyOrdersServlet");
        } else {
            // Show error if order failed
            request.getSession().setAttribute("error", "Failed to place order. Please try again.");
            response.sendRedirect("cart.jsp");
        }
    }

    /**
     * Helper method to check if December discount is active
     */
    public static boolean isDecemberDiscountActive() {
        LocalDate currentDate = LocalDate.now();
        return currentDate.getMonthValue() == 12;
    }

    /**
     * Helper method to calculate December discount
     */
    public static double calculateDecemberDiscount(double originalAmount) {
        if (isDecemberDiscountActive()) {
            return originalAmount * 0.10; // 10% discount
        }
        return 0.0;
    }
}