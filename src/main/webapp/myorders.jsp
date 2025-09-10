<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.Order" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="com.foodparadise.dao.OrderDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch orders from DB
    OrderDAO dao = new OrderDAO();
    List<Order> orders = dao.getOrdersByUser(user.getId());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders — Food Paradise</title>
    <link rel="stylesheet" href="assets/myorders.css?v=1.0">
</head>
<body>
<header class="header">
    <nav class="navbar">
        <div class="logo">Food <p style="color:white;">Paradise</p></div>
        <ul class="nav-links">
            <li><a href="menu.jsp">Find Food</a></li>
            <li><a href="myorders.jsp">My Orders</a></li>
            <li><a href="cart.jsp">Cart</a></li>
        </ul>
        <div class="search-cart">
            <input type="search" class="search-box" placeholder="Search by name...">
            <button class="cart-icon" onclick="location.href='cart.jsp'">🛒</button>
            <button class="login-btn" onclick="location.href='index.jsp'">Login</button>
        </div>
    </nav>
</header>

<main class="container">
    <h2>Your Orders</h2>

    <% if(orders.isEmpty()) { %>
        <p>You have no orders yet.</p>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Total</th>
                    <th>Created At</th>
                </tr>
            </thead>
            <tbody>
                <% for(Order o : orders) { %>
                    <tr>
                        <td><%= o.getId() %></td>
                        <td>$<%= o.getTotal() %></td>
                        <td><%= o.getCreatedAt() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</main>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-logo">Food <span>Paradise</span></div>
        <ul class="footer-links">
            <li><a href="menu.jsp">Menu</a></li>
            <li><a href="myorders.jsp">My Orders</a></li>
            <li><a href="index.jsp">Register</a></li>
        </ul>
        <p class="footer-copy">© 2025 Food Paradise. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
