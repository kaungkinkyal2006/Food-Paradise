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
    <link rel="stylesheet" href="assets/dashboard.css?v=2.0">
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
    <h2>Welcome, <span id="adminName"><%= user.getName() %></span></h2>
    <p>Here you can manage your system. Content below is from the database.</p>

    <div style="margin-bottom: 1.5rem; text-align: right;">
        <a href="addMenu.jsp" id="addNewItem">➕</a>
    </div>

    <div id="admin-content" class="content-grid">
        <% if(menuItems != null && menuItems.size() > 0) { %>
            <% for(MenuItem item : menuItems) { %>
                <div class="card">
                    <c:choose>
                        <c:when test="${not empty item.imgUrl}">
                            <img src="<%= item.getImgUrl() %>" alt="<%= item.getName() %>" class="menu-img">
                        </c:when>
                        <c:otherwise>
                            <div class="menu-img-placeholder">🍽️</div>
                        </c:otherwise>
                    </c:choose>
                    <h3><%= item.getName() %></h3>
                    <p>Category: <%= item.getCategoryId() %></p>
                    <p>Price: MMK<%= item.getPrice() %></p>
                    <p>Stock: <%= item.getStock() %></p>
                    <button class="btn" onclick="location.href='editMenu.jsp?id=<%= item.getId() %>'">Edit</button>
                </div>
            <% } %>
        <% } else { %>
            <p>No menu items found. Add some!</p>
        <% } %>
    </div>
</section>

<footer class="footer">
    <div class="footer-content">
        <div class="footer-logo">🍽️ Food <span>Paradise</span></div>
        <p class="footer-copy">© 2025 Food Paradise. Delivering happiness, one meal at a time! 🍽️❤️</p>
    </div>
</footer>

<style>
    .card {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 1rem;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        background: #fff;
        transition: transform 0.3s;
    }

    .card:hover {
        transform: translateY(-6px);
    }

    .menu-img {
        width: 120px;
        height: 120px;
        object-fit: cover;
        border-radius: 16px;
        margin-bottom: 0.5rem;
    }

    .menu-img-placeholder {
        width: 120px;
        height: 120px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2.5rem;
        background: linear-gradient(135deg, #fff8e1, #ffecb3);
        border-radius: 16px;
        color: #d84315;
        margin-bottom: 0.5rem;
    }

    .btn {
        margin-top: 0.5rem;
        padding: 0.4rem 1rem;
        background-color: #d84315;
        color: #fff;
        border: none;
        border-radius: 8px;
        cursor: pointer;
    }

    .btn:hover {
        background-color: #bf360c;
    }

    .content-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 1.5rem;
    }
</style>
</body>
</html>
