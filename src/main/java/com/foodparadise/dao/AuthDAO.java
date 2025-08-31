package com.foodparadise.dao;

import com.foodparadise.config.DB;
import com.foodparadise.model.User;
import java.sql.*;

public class AuthDAO {

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public int registerUser(String name, String email, String plainPassword, String role,
                            String address, String phone) throws SQLException {
        // store password as plain text (for now)
        String userSql = "INSERT INTO users (role, name, email, password_hash) VALUES (?,?,?,?)";
        String custSql = "INSERT INTO customers (user_id, address, phone) VALUES (?,?,?)";

        try (Connection conn = DB.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, role);
                ps.setString(2, name);
                ps.setString(3, email);
                ps.setString(4, plainPassword);  // <-- store plain password
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int userId = keys.getInt(1);
                    if ("USER".equals(role)) {
                        try (PreparedStatement ps2 = conn.prepareStatement(custSql)) {
                            ps2.setInt(1, userId);
                            ps2.setString(2, address);
                            ps2.setString(3, phone);
                            ps2.executeUpdate();
                        }
                    }
                    conn.commit();
                    return userId;
                } else {
                    conn.rollback();
                    throw new SQLException("Failed to get generated user id");
                }
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public User login(String email, String plainPassword) throws SQLException {
        String sql = "SELECT id, role, name, email, password_hash FROM users WHERE email = ?";
        try (Connection conn = DB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password_hash");
                if (plainPassword.equals(storedPassword)) {  // <-- compare plain text
                    return new User(rs.getInt("id"), rs.getString("role"), rs.getString("name"), rs.getString("email"));
                }
            }
        }
        return null;
    }
}
