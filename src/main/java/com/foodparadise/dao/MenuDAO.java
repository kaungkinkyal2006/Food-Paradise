package com.foodparadise.dao;

import com.foodparadise.config.DB;
import com.foodparadise.model.MenuItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {

    // Fetch all menu items
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> items = new ArrayList<>();
        String sql = "SELECT id, category_id, name, price, img_url, description FROM menu_items";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MenuItem item = new MenuItem(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getString("img_url"),
                        rs.getString("description")
                );
                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }

    // Add new menu item
    public boolean addMenuItem(MenuItem item) {
        String sql = "INSERT INTO menu_items (category_id, name, price, img_url, description) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getCategoryId());
            ps.setString(2, item.getName());
            ps.setDouble(3, item.getPrice());
            ps.setString(4, item.getImgUrl());
            ps.setString(5, item.getDescription());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public MenuItem getMenuItemById(int id) {
        String sql = "SELECT id, category_id, name, price, img_url, description FROM menu_items WHERE id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                return new MenuItem(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getString("img_url"),
                        rs.getString("description")
                );
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateMenuItem(MenuItem item) {
        String sql;
        if(item.getImgUrl() != null) {
            sql = "UPDATE menu_items SET category_id=?, name=?, price=?, img_url=?, description=? WHERE id=?";
        } else {
            sql = "UPDATE menu_items SET category_id=?, name=?, price=?, description=? WHERE id=?";
        }

        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getCategoryId());
            ps.setString(2, item.getName());
            ps.setDouble(3, item.getPrice());

            if(item.getImgUrl() != null) {
                ps.setString(4, item.getImgUrl());
                ps.setString(5, item.getDescription());
                ps.setInt(6, item.getId());
            } else {
                ps.setString(4, item.getDescription());
                ps.setInt(5, item.getId());
            }

            return ps.executeUpdate() > 0;
        } catch(SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMenuItem(int id) {
        String sql = "DELETE FROM menu_items WHERE id=?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }




}
