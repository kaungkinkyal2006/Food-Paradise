<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.PreOrder" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null || !"ADMIN".equals(user.getRole())){
        response.sendRedirect("login.jsp");
        return;
    }

    List<PreOrder> orders = (List<PreOrder>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Orders — Food Paradise</title>
    <link rel="stylesheet" href="assets/adminPreorders.css">
</head>
<body>
<header class="header">
    <nav class="navbar">
        <div class="logo">🍽️ Food <p>Paradise</p></div>
        <ul class="nav-links">
            <li><a href="admin.jsp">Dashboard</a></li>
            <li><a href="AdminOrdersServlet">Orders</a></li>
            <li><a href="AdminPreOrderServlet">Pre-Orders</a></li>
        </ul>
        <div class="search-cart">
            <%
                if(user != null){
            %>
                <form method="get" action="logout" style="display:inline;">
                    <button type="submit" class="login-btn">Logout</button>
                </form>
            <%
                } else {
            %>
                <button class="login-btn" onclick="location.href='auth.jsp'">Login</button>
            <%
                }
            %>
        </div>
    </nav>
</header>

<main class="container">
    <h2>All Pre-Orders</h2>

    <% if(orders == null || orders.isEmpty()) { %>
    <p>No orders found.</p>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th>Order ID</th>
            <th>User Name</th>
            <th>Total</th>
            <th>Ordered At</th>
        </tr>
        </thead>
        <tbody>
        <% for(PreOrder o : orders) { %>
        <tr>
            <td><%= o.getId() %></td>
            <td><%= o.getUserName() %></td>
            <td>MMK<%= o.getTotal() %></td>
            <td><%= o.getCreatedAt() %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
    
</main>
<footer class="footer">
    <div class="footer-content">
        <div class="footer-logo">🍽️ Food <span>Paradise</span></div>
        <p class="footer-copy">© 2025 Food Paradise. Delivering happiness, one meal at a time! 🍽️❤️</p>
    </div>
</footer>
</body>
</html>
