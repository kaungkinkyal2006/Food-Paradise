package com.foodparadise.model;

public class User {
    private int id;
    private String role; // ADMIN or USER
    private String name;
    private String email;

    public User(int id, String role, String name, String email) {
        this.id = id;
        this.role = role;
        this.name = name;
        this.email = email;
    }
    public int getId(){ return id; }
    public String getRole(){ return role; }
    public String getName(){ return name; }
    public String getEmail(){ return email; }
}
