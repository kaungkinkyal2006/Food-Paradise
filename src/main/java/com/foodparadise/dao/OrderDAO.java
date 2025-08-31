package com.foodparadise.dao;

import com.foodparadise.config.DB;
import com.foodparadise.model.OrderItem;
import com.foodparadise.model.Order;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // Your existing createOrder method (kept for backward compatibility)
    public boolean createOrder(int userId, List<OrderItem> items, double total){
        String insertOrder = "INSERT INTO orders(user_id, total, status) VALUES(?, ?, 'PENDING')";
        String insertItem = "INSERT INTO order_items(order_id, item_id, qty, price) VALUES(?, ?, ?, ?)";
        try(Connection conn = DB.getConnection()){
            conn.setAutoCommit(false);

            PreparedStatement psOrder = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, total);
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if(rs.next()) orderId = rs.getInt(1);

            PreparedStatement psItem = conn.prepareStatement(insertItem);
            for(OrderItem item : items){
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getItemId());
                psItem.setInt(3, item.getQty());
                psItem.setDouble(4, item.getPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    // New method to create order with discount information
    public boolean createOrderWithDiscount(int userId, List<OrderItem> items, double originalTotal,
                                           double discountAmount, String discountReason, double finalTotal, String phone){
        // First, check if the orders table has the new discount columns
        String insertOrder = "INSERT INTO orders(user_id, original_total, discount_amount, discount_reason, total, phone, status) VALUES(?, ?, ?, ?, ?, ?, 'PENDING')";
        String insertOrderFallback = "INSERT INTO orders(user_id, total, status) VALUES(?, ?, 'PENDING')";
        String insertItem = "INSERT INTO order_items(order_id, item_id, qty, price) VALUES(?, ?, ?, ?)";

        try(Connection conn = DB.getConnection()){
            conn.setAutoCommit(false);

            PreparedStatement psOrder = null;
            boolean useDiscountColumns = hasDiscountColumns(conn);

            if(useDiscountColumns) {
                // Use the enhanced version with discount columns
                psOrder = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
                psOrder.setInt(1, userId);
                psOrder.setDouble(2, originalTotal);
                psOrder.setDouble(3, discountAmount);
                psOrder.setString(4, discountReason != null ? discountReason : "");
                psOrder.setDouble(5, finalTotal);
                psOrder.setString(6, phone != null ? phone : "");

                System.out.println("Creating order with discount: Original=" + originalTotal +
                        ", Discount=" + discountAmount + ", Final=" + finalTotal);
            } else {
                // Fallback to original version
                psOrder = conn.prepareStatement(insertOrderFallback, Statement.RETURN_GENERATED_KEYS);
                psOrder.setInt(1, userId);
                psOrder.setDouble(2, finalTotal); // Use final total

                System.out.println("Creating order (fallback): Total=" + finalTotal);
            }

            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if(rs.next()) orderId = rs.getInt(1);

            PreparedStatement psItem = conn.prepareStatement(insertItem);
            for(OrderItem item : items){
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getItemId());
                psItem.setInt(3, item.getQty());
                psItem.setDouble(4, item.getPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();

            System.out.println("Order created successfully with ID: " + orderId);
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to check if discount columns exist in orders table
    private boolean hasDiscountColumns(Connection conn) {
        try {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet rs = metaData.getColumns(null, null, "orders", "original_total");
            return rs.next(); // If column exists, return true
        } catch (SQLException e) {
            System.out.println("Could not check for discount columns, using fallback: " + e.getMessage());
            return false;
        }
    }

    // Enhanced method to get orders with discount information
    public List<Order> getOrdersByUserWithDiscount(int userId) {
        List<Order> orders = new ArrayList<>();

        // Try to get orders with discount columns first
        String sqlWithDiscount = "SELECT id, user_id, original_total, discount_amount, discount_reason, total, phone, status, created_at FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        String sqlFallback = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try(Connection conn = DB.getConnection()) {
            PreparedStatement ps = null;

            if(hasDiscountColumns(conn)) {
                ps = conn.prepareStatement(sqlWithDiscount);
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                while(rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setUserId(rs.getInt("user_id"));

                    // Set discount-related fields
                    try {
                        o.setOriginalTotal(rs.getDouble("original_total"));
                        o.setDiscountAmount(rs.getDouble("discount_amount"));
                        o.setDiscountReason(rs.getString("discount_reason"));
                    } catch (SQLException e) {
                        // If columns don't exist, set defaults
                        o.setOriginalTotal(rs.getDouble("total"));
                        o.setDiscountAmount(0.0);
                        o.setDiscountReason("");
                    }

                    o.setTotal(rs.getDouble("total"));
                    o.setStatus(rs.getString("status"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    orders.add(o);
                }
            } else {
                // Fallback to original method
                return getOrdersByUser(userId);
            }
        } catch(Exception e) {
            e.printStackTrace();
            // Fallback to original method
            return getOrdersByUser(userId);
        }
        return orders;
    }

    // Your existing getOrdersByUser method (unchanged)
    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try(Connection conn = DB.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotal(rs.getDouble("total"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(o);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Your existing updateOrderStatus method (unchanged)
    public boolean updateOrderStatus(int orderId, String status){
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try(Connection conn = DB.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Enhanced getAllOrders with discount support
    public List<Order> getAllOrdersWithDiscount() {
        List<Order> orders = new ArrayList<>();
        String sqlWithDiscount = "SELECT id, user_id, original_total, discount_amount, discount_reason, total, phone, status, created_at FROM orders ORDER BY created_at DESC";

        try (Connection conn = DB.getConnection()) {
            if(hasDiscountColumns(conn)) {
                PreparedStatement ps = conn.prepareStatement(sqlWithDiscount);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setUserId(rs.getInt("user_id"));

                    // Set discount-related fields
                    try {
                        o.setOriginalTotal(rs.getDouble("original_total"));
                        o.setDiscountAmount(rs.getDouble("discount_amount"));
                        o.setDiscountReason(rs.getString("discount_reason"));
                    } catch (SQLException e) {
                        o.setOriginalTotal(rs.getDouble("total"));
                        o.setDiscountAmount(0.0);
                        o.setDiscountReason("");
                    }

                    o.setTotal(rs.getDouble("total"));
                    o.setStatus(rs.getString("status"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    orders.add(o);
                }
            } else {
                // Fallback to original method
                return getAllOrders();
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback to original method
            return getAllOrders();
        }
        return orders;
    }

    // Your existing getAllOrders method (unchanged)
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotal(rs.getDouble("total"));
                o.setStatus(rs.getString("status"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }
}