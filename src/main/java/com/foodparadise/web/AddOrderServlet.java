package com.foodparadise.web;

import com.foodparadise.config.DB;
import com.foodparadise.dao.OrderDAO;
import com.foodparadise.dao.MenuDAO;
import com.foodparadise.model.CartItem;
import com.foodparadise.model.OrderItem;
import com.foodparadise.model.MenuItem;
import com.foodparadise.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddOrderServlet")
public class AddOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get the cart from session
        List<CartItem> cart = (List<CartItem>) request.getSession().getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.getSession().setAttribute("error", "Cart is empty!");
            response.sendRedirect("cart.jsp");
            return;
        }

        // Get phone number from form
        String phone = request.getParameter("phone");
        if (phone == null || !phone.matches("\\+959\\d{7,9}")) {
            request.getSession().setAttribute("error", "Please provide a valid phone number (+959XXXXXXXXX)");
            response.sendRedirect("cart.jsp");
            return;
        }

        // Update quantities from form submission
        for (int i = 0; i < cart.size(); i++) {
            String qtyParam = request.getParameter("quantity_" + i);
            int quantity = 1;
            try {
                quantity = Integer.parseInt(qtyParam);
                if (quantity < 1) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
            cart.get(i).setQuantity(quantity);
        }

        MenuDAO menuDAO = new MenuDAO();
        List<String> stockErrors = new ArrayList<>();
        boolean needsPreorder = false;

        // VALIDATE STOCK & PREORDER LIMITS
        for (CartItem item : cart) {
            MenuItem menuItem = menuDAO.getMenuItemById(item.getId());
            if (menuItem == null) {
                stockErrors.add("Item '" + item.getName() + "' not found in menu");
                continue;
            }

            int availableStock = menuItem.getStock();

            if (availableStock == 0) {
                stockErrors.add("'" + item.getName() + "' is out of stock");
                needsPreorder = true;
            } else if (item.getQuantity() > availableStock) {
                stockErrors.add("Only " + availableStock + " units available for '" + item.getName() + "' (you requested " + item.getQuantity() + ")");
                needsPreorder = true;
            }

            // Check if quantity exceeds pre-order limit
            if (item.getQuantity() > 50) {
                needsPreorder = true;
            }
        }

        // Redirect to Pre-Order page if needed
        if (needsPreorder) {
            request.getSession().setAttribute("error", "⚠️ One or more items exceed available stock or 50 units. Please use the Pre-Order page.");
            response.sendRedirect("preorder.jsp");
            return;
        }

        // If there are stock issues (out of stock or below limit), show error on cart page
        if (!stockErrors.isEmpty()) {
            StringBuilder errorMessage = new StringBuilder("Stock Issues Found:\n");
            for (String error : stockErrors) {
                errorMessage.append("• ").append(error).append("\n");
            }
            request.getSession().setAttribute("error", errorMessage.toString());
            response.sendRedirect("cart.jsp");
            return;
        }

        // Convert CartItem -> OrderItem and calculate totals
        List<OrderItem> orderItems = new ArrayList<>();
        double originalTotal = 0;
        for (CartItem item : cart) {
            originalTotal += item.getPrice() * item.getQuantity();
            orderItems.add(new OrderItem(0, 0, item.getId(), item.getQuantity(), item.getPrice()));
        }

        // === Apply Discounts ===
        double discountAmount = 0;
        double finalTotal = originalTotal;
        String discountReason = "";
        boolean hasDiscount = false;

        LocalDate currentDate = LocalDate.now();
        int month = currentDate.getMonthValue();

        if (month == 12) {
            discountAmount += originalTotal * 0.10;
            discountReason += "December Discount (10%) ";
            hasDiscount = true;
        }
        if (month >= 4 && month <= 10) {
            discountAmount += originalTotal * 0.20;
            discountReason += "Rainy Season Discount (20%) ";
            hasDiscount = true;
        }

        if (discountAmount > 0) {
            finalTotal = originalTotal - discountAmount;
        }

        // Create order in DB
        OrderDAO dao = new OrderDAO();
        boolean success;
        try {
            success = dao.createOrderWithDiscount(
                    user.getId(), orderItems, originalTotal,
                    discountAmount, discountReason.trim(), finalTotal, phone
            );
        } catch (Exception e) {
            System.out.println("Fallback createOrder method: " + e.getMessage());
            success = dao.createOrder(user.getId(), orderItems, finalTotal);
        }

        if (success) {
            // Update stock safely
            try (Connection conn = DB.getConnection()) {
                for (CartItem item : cart) {
                    String updateStockQuery = "UPDATE menu_items SET stock = stock - ? WHERE id = ? AND stock >= ?";
                    try (PreparedStatement ps = conn.prepareStatement(updateStockQuery)) {
                        ps.setInt(1, item.getQuantity());
                        ps.setInt(2, item.getId());
                        ps.setInt(3, item.getQuantity());
                        int rows = ps.executeUpdate();
                        if (rows == 0) {
                            request.getSession().setAttribute("error",
                                    "Order processing failed due to stock sync issue. Please try again.");
                            response.sendRedirect("cart.jsp");
                            return;
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Order created but stock update failed. Please contact support.");
                response.sendRedirect("cart.jsp");
                return;
            }

            // Save order details for confirmation
            request.getSession().setAttribute("lastOrderOriginalTotal", originalTotal);
            request.getSession().setAttribute("lastOrderDiscountAmount", discountAmount);
            request.getSession().setAttribute("lastOrderFinalTotal", finalTotal);
            request.getSession().setAttribute("lastOrderDiscountReason", discountReason.trim());
            request.getSession().setAttribute("lastOrderPhone", phone);

            request.getSession().removeAttribute("cart");

            if (hasDiscount) {
                request.getSession().setAttribute("success",
                        String.format("Order placed successfully! 🎉 You saved MMK%.2f (%s) Final total: MMK%.2f",
                                discountAmount, discountReason.trim(), finalTotal));
            } else {
                request.getSession().setAttribute("success",
                        String.format("Order placed successfully! Total: MMK%.2f", finalTotal));
            }

            response.sendRedirect("MyOrdersServlet");
        } else {
            request.getSession().setAttribute("error", "Failed to place order. Please try again.");
            response.sendRedirect("cart.jsp");
        }
    }
}
