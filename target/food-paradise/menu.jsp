<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.MenuItem" %>
<%@ page import="com.foodparadise.dao.MenuDAO" %>

<%
    MenuDAO menuDao = new MenuDAO();
    java.util.List<MenuItem> menuItems = menuDao.getAllMenuItems();
    request.setAttribute("menuItems", menuItems);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Food Paradise — Menu</title>
    <link rel="stylesheet" href="assets/menu.css?v=2">
</head>
<body>
<header class="topbar">
    <h1>Food Paradise</h1>
    <nav>
        <a href="menu.jsp">Menu</a>
        <a href="cart.jsp">Cart</a>
        <a href="myorders.jsp">My Orders</a>
        <a href="logout">Logout</a>
    </nav>
</header>

<main class="container">
    <h2>Browse Menu</h2>

    <section>
        <h3>Food</h3>
        <div class="chips">
            <button type="button" class="chip" data-category="1">Myanmar Food</button>
            <button type="button" class="chip" data-category="2">Thai Food</button>
            <button type="button" class="chip" data-category="3">Chinese Food</button>
        </div>
    </section>

    <section>
        <h3>Drink</h3>
        <div class="chips">
            <button type="button" class="chip" data-category="4">Cafe</button>
            <button type="button" class="chip" data-category="5">Fruit Juice & Yogurt</button>
            <button type="button" class="chip" data-category="6">Bubble Tea & Smoothie</button>
        </div>
    </section>

    <div id="items" class="grid">
        <c:choose>
            <c:when test="${not empty menuItems}">
                <c:forEach var="item" items="${menuItems}">
                    <div class="card" data-category="${item.categoryId}">
                        <div class="card-image">
                            <c:if test="${not empty item.imgUrl}">
                                <img src="${item.imgUrl}" alt="${item.name}">
                            </c:if>
                        </div>
                        <div class="card-content">
                            <h4>${item.name}</h4>
                            <p class="description">${item.description}</p>
                            <p class="price">MMK${item.price}</p>
                        </div>
                        <form action="CartServlet" method="post" class="card-footer">
                            <input type="hidden" name="id" value="${item.id}">
                            <input type="hidden" name="name" value="${item.name}">
                            <input type="hidden" name="price" value="${item.price}">
                            <input type="number" name="quantity" value="1" min="1">
                            <button type="submit" class="btn">🛒 Add to Cart</button>
                        </form>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>No menu items found.</p>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
    const chips = document.querySelectorAll('.chip');
    const cards = document.querySelectorAll('.card');

    chips.forEach(chip => {
        chip.addEventListener('click', () => {
            const category = chip.getAttribute('data-category');
            cards.forEach(card => {
                card.style.display = (card.getAttribute('data-category') === category || category === '') ? 'block' : 'none';
            });
        });
    });
</script>
</body>
</html>
