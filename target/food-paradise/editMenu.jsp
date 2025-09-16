<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="com.foodparadise.model.MenuItem" %>
<%@ page import="com.foodparadise.dao.MenuDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if(idStr == null){
        response.sendRedirect("admin.jsp");
        return;
    }

    int id = Integer.parseInt(idStr);
    MenuDAO dao = new MenuDAO();
    MenuItem item = dao.getMenuItemById(id); // Ensure DAO method exists
    if(item == null){
        response.sendRedirect("admin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Menu Item — Food Paradise</title>
    <link rel="stylesheet" href="assets/editmenu.css?v=2.0">
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

<section class="dashboard-container">
    <h2>Edit Menu Item</h2>

    <div style="max-width: 500px; margin: 2rem auto;">
        <form action="EditMenuServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= item.getId() %>">

            <label for="name">Item Name:</label>
            <input type="text" id="name" name="name" value="<%= item.getName() %>" required>

            <label for="category">Category:</label>
            <select id="category" name="category" required>
                <option value="Myanmar Food" <%= item.getCategoryId()==1?"selected":"" %>>Myanmar Food</option>
                <option value="Thai Food" <%= item.getCategoryId()==2?"selected":"" %>>Thai Food</option>
                <option value="Chinese Food" <%= item.getCategoryId()==3?"selected":"" %>>Chinese Food</option>
                <option value="Cafe" <%= item.getCategoryId()==4?"selected":"" %>>Cafe</option>
                <option value="Fruit Juice & Yogurt" <%= item.getCategoryId()==5?"selected":"" %>>Fruit Juice & Yogurt</option>
                <option value="Bubble Tea & Smoothie" <%= item.getCategoryId()==6?"selected":"" %>>Bubble Tea & Smoothie</option>
            </select>

            <label for="price">Price (MMK):</label>
            <input type="number" id="price" name="price" value="<%= item.getPrice() %>" step="0.01" required>

            <label for="stock">Stock:</label>
            <input type="number" id="stock" name="stock" value="<%= item.getStock() %>" min="0" required>

            <label for="image">Change Image (optional):</label>
            <input type="file" id="image" name="image" accept="image/*">

            <label for="description">Description:</label>
            <textarea id="description" name="description"><%= item.getDescription() %></textarea>

            <button type="submit" class="btn">💾 Update Item</button>
        </form>
        <form action="DeleteMenuServlet" method="post" style="margin-top:1rem;">
            <input type="hidden" name="id" value="<%= item.getId() %>">
            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete <%= item.getName() %>?');">
                🗑️ Delete Item
            </button>
        </form>
    </div>
</section>
<footer class="footer">
    <div class="footer-content">
        <div class="footer-logo">🍽️ Food <span>Paradise</span></div>
        <p class="footer-copy">© 2025 Food Paradise. Delivering happiness, one meal at a time! 🍽️❤️</p>
    </div>
</footer>
</body>
</html>
