package com.foodparadise.dao;

import com.foodparadise.config.DB;
import com.foodparadise.model.Order;
import com.foodparadise.model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // Create order (without status)
    public boolean createOrder(int userId, List<OrderItem> items, double total){
        String insertOrder = "INSERT INTO orders(user_id, total) VALUES(?, ?)";
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
        } catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    // Create order with discount (without status)
    public boolean createOrderWithDiscount(int userId, List<OrderItem> items, double originalTotal,
                                           double discountAmount, String discountReason, double finalTotal, String phone){
        String insertOrderWithDiscount = "INSERT INTO orders(user_id, original_total, discount_amount, discount_reason, total, phone) VALUES(?, ?, ?, ?, ?, ?)";
        String insertItem = "INSERT INTO order_items(order_id, item_id, qty, price) VALUES(?, ?, ?, ?)";

        try(Connection conn = DB.getConnection()){
            conn.setAutoCommit(false);

            PreparedStatement psOrder = conn.prepareStatement(insertOrderWithDiscount, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, originalTotal);
            psOrder.setDouble(3, discountAmount);
            psOrder.setString(4, discountReason != null ? discountReason : "");
            psOrder.setDouble(5, finalTotal);
            psOrder.setString(6, phone != null ? phone : "");
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
        } catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    // Get orders by user
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
                o.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(o);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    // Get all orders
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try(Connection conn = DB.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotal(rs.getDouble("total"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(o);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    // Note: updateOrderStatus is removed because status column no longer exists
}
