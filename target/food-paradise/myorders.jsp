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

    // Always fetch orders from DB
    OrderDAO dao = new OrderDAO();
    List<Order> orders = dao.getOrdersByUser(user.getId());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders — Food Paradise</title>
    <link rel="stylesheet" href="assets/myorders.css">
</head>
<body>
<header class="topbar">
    <h1>My Orders</h1>
    <nav>
        <a href="menu.jsp">Menu</a>
        <a href="cart.jsp">Cart</a>
        <a href="MyOrdersServlet">My Orders</a>
        <a href="logout">Logout</a>
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
            <th>Status</th>
            <th>Created At</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <% for(Order o : orders) { %>
        <tr>
            <td><%= o.getId() %></td>
            <td>$<%= o.getTotal() %></td>
            <td><%= o.getStatus() %></td>
            <td><%= o.getCreatedAt() %></td>
            <td>
                <% if("PENDING".equals(o.getStatus())) { %>
                <form action="UpdateOrderStatusServlet" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="<%= o.getId() %>">
                    <button type="submit" class="btn">Mark Arrived</button>
                </form>
                <% } else { %>
                <span>—</span>
                <% } %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</main>
</body>
</html>
