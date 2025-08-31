package com.foodparadise.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

public class DB {
    private static String url;
    private static String user;
    private static String password;

    static {
        try {
            Properties props = new Properties();
            InputStream in = DB.class.getClassLoader().getResourceAsStream("application.properties");
            props.load(in);

            url = props.getProperty("db.url");
            user = props.getProperty("db.user");
            password = props.getProperty("db.password");

            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            throw new RuntimeException("Failed loading DB config: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}
