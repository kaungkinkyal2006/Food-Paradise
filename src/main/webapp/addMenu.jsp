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
    <link rel="stylesheet" href="assets/addmenu.css">
</head>
<body>
<header class="navbar">
    <div class="logo">🍽️ Food Paradise</div>
    <ul class="nav-links">
        <li><a href="admin.jsp">Dashboard</a></li>
        <li><a href="adminOrders.jsp">Orders</a></li>
        <li><a href="logout">Logout</a></li>
    </ul>
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

                <label for="image">Choose Image (optional):</label>
                <input type="file" id="image" name="image" accept="image/*">

                <label for="description">Description (optional):</label>
                <textarea id="description" name="description" placeholder="Describe the item"></textarea>

                <button type="submit" class="btn">➕ Add Item</button>
            </div>
        </form>

    </div>
</section>

<footer>
    <p>&copy; 2025 Food Paradise. All rights reserved.</p>
</footer>
</body>
</html>
