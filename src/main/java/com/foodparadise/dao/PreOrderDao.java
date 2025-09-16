package com.foodparadise.dao;

import com.foodparadise.config.DB;
import com.foodparadise.model.PreOrder;
import com.foodparadise.model.PreOrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PreOrderDao {

    // Create preorder (without discount)
    public boolean createPreOrder(int userId, List<PreOrderItem> items, double total, double deliveryFee, Date expectedDate) {
        String insertPreOrder = "INSERT INTO pre_orders(user_id, total, delivery_fee, expected_date) VALUES(?, ?, ?, ?)";
        String insertItem = "INSERT INTO order_items(order_id, item_id, qty, price) VALUES(?, ?, ?, ?)";

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement psOrder = conn.prepareStatement(insertPreOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, total);
            psOrder.setDouble(3, deliveryFee);
            psOrder.setDate(4, expectedDate);
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) orderId = rs.getInt(1);

            PreparedStatement psItem = conn.prepareStatement(insertItem);
            for (PreOrderItem item : items) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getItemId());
                psItem.setInt(3, item.getQty());
                psItem.setDouble(4, item.getPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Create preorder with discount
    public boolean createPreOrderWithDiscount(int userId, List<PreOrderItem> items, double originalTotal,
                                              double discountAmount, String discountReason, double finalTotal,
                                              String phone, double deliveryFee, Date expectedDate) {

        String insertPreOrder = "INSERT INTO pre_orders(user_id, original_total, discount_amount, discount_reason, total, phone, delivery_fee, expected_date) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        String insertItem = "INSERT INTO order_items(order_id, item_id, qty, price) VALUES(?, ?, ?, ?)";

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement psOrder = conn.prepareStatement(insertPreOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, userId);
            psOrder.setDouble(2, originalTotal);
            psOrder.setDouble(3, discountAmount);
            psOrder.setString(4, discountReason != null ? discountReason : "");
            psOrder.setDouble(5, finalTotal);
            psOrder.setString(6, phone != null ? phone : "");
            psOrder.setDouble(7, deliveryFee);
            psOrder.setDate(8, expectedDate);
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) orderId = rs.getInt(1);

            PreparedStatement psItem = conn.prepareStatement(insertItem);
            for (PreOrderItem item : items) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getItemId());
                psItem.setInt(3, item.getQty());
                psItem.setDouble(4, item.getPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get preorders by user
    public List<PreOrder> getPreOrdersByUser(int userId) {
        List<PreOrder> preOrders = new ArrayList<>();
        String sql = "SELECT * FROM pre_orders WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PreOrder o = new PreOrder();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setTotal(rs.getDouble("total"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                o.setOriginalTotal(rs.getDouble("original_total"));
                o.setDiscountAmount(rs.getDouble("discount_amount"));
                o.setDiscountReason(rs.getString("discount_reason"));
                o.setPhone(rs.getString("phone"));

                // handle nullable deliveryFee
                double deliveryFee = rs.getDouble("delivery_fee");
                if (rs.wasNull()) deliveryFee = 0.0;
                o.setDeliveryFee(deliveryFee);

                o.setExpectedAt(rs.getDate("expected_date"));
                preOrders.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return preOrders;
    }

    // Get all preorders
    public List<PreOrder> getAllPreOrders() {
    List<PreOrder> preOrders = new ArrayList<>();
    String sql = "SELECT p.*, u.name AS user_name " +
                 "FROM pre_orders p " +
                 "JOIN users u ON p.user_id = u.id " +
                 "ORDER BY p.created_at DESC";

    try (Connection conn = DB.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            PreOrder o = new PreOrder();
            o.setId(rs.getInt("id"));
            o.setUserId(rs.getInt("user_id"));
            o.setUserName(rs.getString("user_name")); // NEW FIELD
            o.setTotal(rs.getDouble("total"));
            o.setCreatedAt(rs.getTimestamp("created_at"));
            o.setOriginalTotal(rs.getDouble("original_total"));
            o.setDiscountAmount(rs.getDouble("discount_amount"));
            o.setDiscountReason(rs.getString("discount_reason"));
            o.setPhone(rs.getString("phone"));

            double deliveryFee = rs.getDouble("delivery_fee");
            if (rs.wasNull()) deliveryFee = 0.0;
            o.setDeliveryFee(deliveryFee);

            o.setExpectedAt(rs.getDate("expected_date"));
            preOrders.add(o);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return preOrders;
}

}
