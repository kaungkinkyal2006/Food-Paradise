<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="com.foodparadise.dao.MenuDAO" %>
<%@ page import="com.foodparadise.model.MenuItem" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch existing menu items from DB
    MenuDAO menuDao = new MenuDAO();
    List<MenuItem> menuItems = menuDao.getAllMenuItems();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard — Food Paradise</title>
    <link rel="stylesheet" href="assets/dashboard.css">
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

<section class="dashboard-container">
    <h2>Welcome, <span id="adminName"><%= user.getName() %></span></h2>
    <p>Here you can manage your system. Content below is from the database.</p>

    <!-- Add new menu item button -->
    <div style="margin-bottom: 1.5rem; text-align: right;">
        <a href="addMenu.jsp" class="btn">➕ Add New Item</a>
    </div>


    <div id="admin-content" class="content-grid">
    <% if(menuItems != null && menuItems.size() > 0) { %>
    <% for(MenuItem item : menuItems) { %>
    <div class="card">
        <h3><%= item.getName() %></h3>
        <p>Category: <%= item.getCategoryId() %></p>
        <p>Price: MMK<%= item.getPrice() %></p>
        <p>Stock: <%= item.getStock() %></p> <!-- added stock display -->
        <button class="btn" onclick="location.href='editMenu.jsp?id=<%= item.getId() %>'">Edit</button>
    </div>
    <% } %>
    <% } else { %>
    <p>No menu items found. Add some!</p>
    <% } %>
</div>


</section>

<footer>
    <p>&copy; 2025 Food Paradise. All rights reserved.</p>
</footer>
</body>
</html>
