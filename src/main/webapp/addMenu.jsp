<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Menu Item — Food Paradise</title>
    <link rel="stylesheet" href="assets/addmenu.css?v=2.0">
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
    <h2>Add New Menu Item</h2>
    <p>Fill in the details below to create a new food or drink item.</p>

    <div style="max-width: 500px; margin: 2rem auto;">
        <form action="AddMenuServlet" method="post" class="content-grid" style="gap: 1rem;" enctype="multipart/form-data">
            <div class="card" style="padding: 1rem;">
                <label for="name">Item Name:</label>
                <input type="text" id="name" name="name" required placeholder="E.g., Fried Rice">

                <label for="category">Category:</label>
                <select id="category" name="category" required>
                    <option value="">Select category</option>
                    <option value="Myanmar Food">Myanmar Food</option>
                    <option value="Thai Food">Thai Food</option>
                    <option value="Chinese Food">Chinese Food</option>
                    <option value="Cafe">Cafe</option>
                    <option value="Fruit Juice & Yogurt">Fruit Juice & Yogurt</option>
                    <option value="Bubble Tea & Smoothie">Bubble Tea & Smoothie</option>
                </select>

                <label for="price">Price (MMK):</label>
                <input type="number" id="price" name="price" step="0.01" required placeholder="E.g., 3500">

                <label for="stock">Stock:</label>
                <input type="number" id="stock" name="stock" min="0" required placeholder="E.g., 50">

                <label for="image">Choose Image (optional):</label>
                <input type="file" id="image" name="image" accept="image/*">

                <label for="description">Description (optional):</label>
                <textarea id="description" name="description" placeholder="Describe the item"></textarea>

                <button type="submit" class="btn">➕ Add Item</button>
            </div>
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
