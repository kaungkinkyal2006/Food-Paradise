<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.Order" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"ADMIN".equals(user.getRole())){
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Orders — Food Paradise</title>
    <link rel="stylesheet" href="assets/adminorders.css">
</head>
<body>
<header class="navbar">
    <div class="logo">🍽️ Food Paradise</div>
    <ul class="nav-links">
        <li><a href="admin.jsp">Dashboard</a></li>
        <li><a href="AdminOrdersServlet">Orders</a></li>
        <li><a href="logout">Logout</a></li>
    </ul>
</header>

<main class="container">
    <h2>All Orders</h2>

    <% if(orders == null || orders.isEmpty()) { %>
    <p>No orders found.</p>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th>Order ID</th>
            <th>User ID</th>
            <th>Total</th>
            <th>Created At</th>
        </tr>
        </thead>
        <tbody>
        <% for(Order o : orders) { %>
        <tr>
            <td><%= o.getId() %></td>
            <td><%= o.getUserId() %></td>
            <td>MMK<%= o.getTotal() %></td>
            <td><%= o.getCreatedAt() %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</main>
</body>
</html>
