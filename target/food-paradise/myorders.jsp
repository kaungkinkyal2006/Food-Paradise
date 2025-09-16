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
    <link rel="stylesheet" href="assets/myorders.css?v=2.0">
</head>
<body>
<header class="header">
    <nav class="navbar">
        <div class="logo">
                🍽️ Food <p>Paradise</p>
            </div>
        <ul class="nav-links">
            <li><a href="menu.jsp">🏠 Home</a></li>
            <li><a href="menu.jsp">🍽️ Menu</a></li>
            <li><a href="myorders.jsp">📋 My Orders</a></li>
            <li><a href="myPreorder.jsp">📅 My Preorders</a></li>
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
    <h2>Your Orders</h2>

    <% if(orders.isEmpty()) { %>
        <p>You have no preorders yet.</p>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Original Total</th>
                    <th>Delivery Fee</th>
                    <th>Discount</th>
                    <th>Final Total</th>
                    <th>Phone</th>
                    <th>Ordered At</th>
                </tr>
            </thead>
            <tbody>
                <% for(Order o : orders) { %>
                    <tr>
                        <td data-label="Order ID"><%= o.getId() %></td>
                        <td data-label="Original Total">MMK<%= o.getOriginalTotal() %></td>
                        <td data-label="Delivery Fee">
    <%= o.getDeliveryFee() != null ? "MMK" + o.getDeliveryFee() : "-" %>
</td>
                        <td data-label="Discount">
                            MMK<%= o.getDiscountAmount() %> 
                            <% if(o.getDiscountAmount() > 0) { %>
                                (<%= o.getDiscountReason() %>)
                            <% } %>
                        </td>
                        <td data-label="Final Total">MMK<%= o.getTotal() %></td>
                        <td data-label="Phone"><%= o.getPhone() != null ? o.getPhone() : "-" %></td>
                        <td data-label="Created At"><%= o.getCreatedAt() %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</main>

<!-- Footer -->
<footer class="footer">
    <div class="footer-content">
        <div class="footer-logo">🍽️ Food <span>Paradise</span></div>
        <ul class="footer-links">
            <li><a href="menu.jsp">🏠 Home</a></li>
            <li><a href="menu.jsp">📖 Menu</a></li>
            <li><a href="myorders.jsp">📋 My Orders</a></li>
            <li><a href="cart.jsp">🛒 Cart</a></li>
            <li><a href="auth.jsp">🔐 Account</a></li>
        </ul>
        <p class="footer-copy">© 2025 Food Paradise. Delivering happiness, one meal at a time! 🍽️❤️</p>
    </div>
</footer>

</body>
</html>
