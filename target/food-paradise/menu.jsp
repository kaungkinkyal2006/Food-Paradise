<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.MenuItem" %>
<%@ page import="com.foodparadise.dao.MenuDAO" %>

<%
    MenuDAO menuDao = new MenuDAO();
    java.util.List<MenuItem> menuItems = menuDao.getAllMenuItems();
    request.setAttribute("menuItems", menuItems);

    java.util.List<MenuItem> popularItems = new java.util.ArrayList<>(menuItems);
    java.util.Collections.shuffle(popularItems); // shuffle randomly
    if (popularItems.size() > 4) {
        popularItems = popularItems.subList(0, 4); // pick only 4
    }
    request.setAttribute("popularItems", popularItems);
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader ("Expires", 0);

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Paradise — Taste the Best</title>
    <link rel="stylesheet" href="assets/menu.css?v=1.0">

    <meta name="theme-color" content="#0f1f05" />
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />

    
</head>
<body>
    <!-- Floating leaves animation -->
    <div class="leaf" style="left: 10%; animation-delay: 0s;"></div>
    <div class="leaf" style="left: 20%; animation-delay: 2s;"></div>
    <div class="leaf" style="left: 30%; animation-delay: 4s;"></div>
    <div class="leaf" style="left: 40%; animation-delay: 6s;"></div>
    <div class="leaf" style="left: 50%; animation-delay: 1s;"></div>
    <div class="leaf" style="left: 60%; animation-delay: 3s;"></div>
    <div class="leaf" style="left: 70%; animation-delay: 5s;"></div>
    <div class="leaf" style="left: 80%; animation-delay: 7s;"></div>
    <div class="leaf" style="left: 90%; animation-delay: 2.5s;"></div>

    <!-- Header -->
    <header class="header">
    <nav class="navbar">
        <div class="logo">Food <p style="color: white;">Paradise</p></div>
        <ul class="nav-links">
            <li><a href="menu.jsp">Find Food</a></li>
            <li><a href="myorders.jsp">My Orders</a></li>
            <li><a href="cart.jsp">Cart</a></li>
        </ul>
        <div class="search-cart">
    <!-- Search Bar -->
    <input type="search" class="search-box" placeholder="Search by name...">

    <!-- Cart Button -->
    <button class="cart-icon" onclick="location.href='cart.jsp'">🛒</button>

    <!-- Login / Logout -->
    <c:choose>
        <c:when test="${not empty sessionScope.user}">
            <button class="login-btn" onclick="location.href='logout.jsp'">Logout</button>
        </c:when>
        <c:otherwise>
            <button class="login-btn" onclick="location.href='index.jsp'">Login</button>
        </c:otherwise>
    </c:choose>
</div>

    </nav>
</header>


    <main class="container">
        <!-- Hero Section -->
        <section class="hero">
    <div class="hero-content">
        <!-- Promotion / Item Badge -->
        <span class="hero-badge" id="heroBadge">🔥 Featured Special!</span>
        
        <!-- Title & Description -->
        <h1 id="heroTitle">Taste the Best that<br>Surprise You</h1>
        <p id="heroDescription">Discover our amazing menu items with fresh ingredients and authentic flavors.</p>
        
        <!-- Pricing -->
        <div class="hero-price" id="heroPricing" style="display: flex;">
            <span class="current-price" id="heroPrice">MMK 15,000</span>
            <span class="original-price" id="heroOriginalPrice">MMK 25,000</span>
        </div>
        
        <!-- Buttons -->
        <div class="hero-buttons" id="heroButtons" style="display: flex;">
            <button class="btn-primary" id="heroBuyBtn" onclick="document.getElementById('items').scrollIntoView({behavior: 'smooth'})">Buy Now</button>
            <button class="btn-secondary" id="heroMenuBtn" onclick="document.getElementById('items').scrollIntoView({behavior: 'smooth'})">See Menu</button>
        </div>
    </div>
    
    <!-- Hero Image / Dish -->
    <div class="hero-image">
        <div class="hero-dish" id="heroDish">
            <!-- JS will replace this with proper image -->
            <img src="assets/placeholder-dish.png" alt="Featured Dish">
        </div>
    </div>
</section>

        <!-- Popular Menu Section -->
        <div class="popular-section">
            <h2 class="section-title">🌟 Popular Menu</h2>
            <div class="popular-items">
                <c:forEach var="item" items="${popularItems}">
                    <div class="popular-card" onclick="selectItemFromRow('${item.id}', '${item.name}', '${item.description}', '${item.price}', '${item.imgUrl}', this)">
                        <c:choose>
                            <c:when test="${not empty item.imgUrl}">
                                <img src="${item.imgUrl}" alt="${item.name}">
                            </c:when>
                            <c:otherwise>
                                <div style="width:80px; height:80px; display:flex; align-items:center; justify-content:center; font-size:2rem; background: rgba(255,255,255,0.1); border-radius:50%;">🍽️</div>
                            </c:otherwise>
                        </c:choose>
                        <h4>${item.name}</h4>
                        <div class="price">MMK ${item.price}</div>
                        <form action="CartServlet" method="post" style="margin-top: 10px;" onclick="event.stopPropagation();">
                            <input type="hidden" name="id" value="${item.id}">
                            <input type="hidden" name="name" value="${item.name}">
                            <input type="hidden" name="price" value="${item.price}">
                            <div class="quantity-cart">
                                <input type="number" name="quantity" value="1" min="1" style="width:40px; margin-right: 5px;">
                                <button type="submit" class="add-to-cart-small">🛒</button>
                            </div>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Categories -->
        <div class="categories">
            <div class="category-section">
                <h3 class="category-title">Food</h3>
                <div class="chips">
                    <button type="button" class="chip" data-category="1">Myanmar Food</button>
                    <button type="button" class="chip" data-category="2">Thai Food</button>
                    <button type="button" class="chip" data-category="3">Chinese Food</button>
                </div>
            </div>

            <div class="category-section">
                <h3 class="category-title">Drink</h3>
                <div class="chips">
                    <button type="button" class="chip" data-category="4">Cafe</button>
                    <button type="button" class="chip" data-category="5">Fruit Juice & Yogurt</button>
                    <button type="button" class="chip" data-category="6">Bubble Tea & Smoothie</button>
                </div>
            </div>
        </div>

        <div>
        <!-- Menu Items -->
            <div class="menu-grid" id="items">
    <c:forEach var="item" items="${menuItems}">
        <div class="menu-card" data-category="${item.categoryId}">
            <c:choose>
                <c:when test="${not empty item.imgUrl}">
                    <img src="${item.imgUrl}" alt="${item.name}">
                </c:when>
                <c:otherwise>
                    <div style="width:100%; height:150px; display:flex; align-items:center; justify-content:center; font-size:3rem;">🍽️</div>
                </c:otherwise>
            </c:choose>
            <div class="menu-card-content">
                <h4>${item.name}</h4>
                <div class="price">MMK ${item.price}</div>
                <form action="CartServlet" method="post" style="margin-top: 10px;">
                    <input type="hidden" name="id" value="${item.id}">
                    <input type="hidden" name="name" value="${item.name}">
                    <input type="hidden" name="price" value="${item.price}">
                    <div class="quantity-add-section">
                        <input type="number" name="quantity" value="1" min="1" style="width:30px;">
                        <button type="submit" class="add-to-cart">🛒 Add to Cart</button>
                    </div>
                </form>
            </div>
        </div>
    </c:forEach>
</div>

<!-- Modal -->
<div id="itemModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <div id="modalBody"></div>
  </div>
</div>

    </main>
    <!-- Footer -->

    
<footer class="footer">
    <div class="footer-content">
        <div class="footer-logo">Food <span>Paradise</span></div>
        <ul class="footer-links">
            <li><a href="menu.jsp">Menu</a></li>
            <li><a href="myorders.jsp">My Orders</a></li>
            <li><a href="index.jsp">Register</a></li>
        </ul>
        <p class="footer-copy">© 2025 Food Paradise. All rights reserved.</p>
    </div>
</footer>


    <script>
        // Store selected item data
        let selectedItem = null;
        let isSeasonalPromotion = false;

        // Function to check and set seasonal promotions
        function checkSeasonalPromotion() {
            const today = new Date();
            const month = today.getMonth() + 1; // 0-based, so add 1
            
            if (month >= 4 && month <= 10) {
                // Rainy season promotion (April to October)
                document.getElementById('heroBadge').textContent = "🌧️ RAINY SEASON MEGA SALE!";
                document.getElementById('heroTitle').innerHTML = "🔥 GET 20% OFF EVERYTHING! 🔥<br><span style='font-size: 1.5rem; color: #8bc34a;'>Limited Time Only!</span>";
                document.getElementById('heroDescription').textContent = "Beat the rain with amazing discounts! Order now and enjoy cozy meals delivered right to your door. Don't miss this incredible deal!";
                document.getElementById('heroPrice').textContent = "UP TO 20% OFF";
                document.getElementById('heroOriginalPrice').textContent = "EVERYTHING";
                document.getElementById('heroPricing').style.display = 'flex';
                document.getElementById('heroButtons').style.display = 'flex';
                
                // Cool promotional display instead of image
                document.getElementById('heroDish').innerHTML = `
                    <div style="width: 280px; height: 280px; background: linear-gradient(135deg, #ff6b35, #8bc34a, #2196f3); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; font-size: 3rem; box-shadow: 0 20px 40px rgba(0,0,0,0.4); animation: promotional-glow 2s infinite alternate;">
                        <div style="font-size: 4rem; margin-bottom: 10px;">🌧️</div>
                        <div style="font-size: 2rem; font-weight: 900; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);">20%</div>
                        <div style="font-size: 1rem; color: white; font-weight: 600;">OFF</div>
                    </div>`;
                isSeasonalPromotion = true;
                return true;
            } else if (month === 12) {
                // December promotion
                document.getElementById('heroBadge').textContent = "🎄 DECEMBER MEGA DEALS!";
                document.getElementById('heroTitle').innerHTML = "🎉 FESTIVE SEASON SPECIALS! 🎉<br><span style='font-size: 1.5rem; color: #8bc34a;'>Holiday Treats Await!</span>";
                document.getElementById('heroDescription').textContent = "Celebrate the holidays with amazing food deals! Special festive menu items and incredible discounts throughout December!";
                document.getElementById('heroPricing').style.display = 'none';
                document.getElementById('heroButtons').style.display = 'flex';
                
                // Cool Christmas promotional display
                document.getElementById('heroDish').innerHTML = `
                    <div style="width: 280px; height: 280px; background: linear-gradient(135deg, #e91e63, #4caf50, #ff9800); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; font-size: 3rem; box-shadow: 0 20px 40px rgba(0,0,0,0.4); animation: promotional-glow 2s infinite alternate;">
                        <div style="font-size: 4rem; margin-bottom: 10px;">🎄</div>
                        <div style="font-size: 1.5rem; font-weight: 900; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);">FESTIVE</div>
                        <div style="font-size: 1rem; color: white; font-weight: 600;">DEALS</div>
                    </div>`;
                isSeasonalPromotion = true;
                return true;
            }
            
            isSeasonalPromotion = false;
            return false;
        }

        // Function to select item from the featured row and display in hero
        function selectItemFromRow(id, name, description, price, imgUrl, cardElement) {
            // Don't allow selection if seasonal promotion is active
            if (isSeasonalPromotion) {
                return;
            }
            
            // Remove previous selection from featured row
            document.querySelectorAll('.popular-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selection to clicked card
            cardElement.classList.add('selected');
            
            // Store selected item data
            selectedItem = { id, name, description, price, imgUrl };
            
            // Update hero section
            document.getElementById('heroBadge').textContent = '🔥 FEATURED SPECIAL!';
            document.getElementById('heroTitle').innerHTML = name;
            document.getElementById('heroDescription').textContent = description || 'Delicious and fresh, made with the finest ingredients just for you.';
            document.getElementById('heroPrice').textContent = `MMK ${price}`;
            
            // Calculate original price (25% higher for demo)
            const originalPrice = Math.round(parseFloat(price) * 1.25);
            document.getElementById('heroOriginalPrice').textContent = `MMK ${originalPrice}`;
            
            // Show pricing and buttons
            document.getElementById('heroPricing').style.display = 'flex';
            document.getElementById('heroButtons').style.display = 'flex';
            
            // Update hero image
            const heroDish = document.getElementById('heroDish');
            if (imgUrl && imgUrl.trim() !== '' && imgUrl !== 'null') {
                heroDish.innerHTML = `<img src="${imgUrl}" alt="${name}" style="width: 280px; height: 280px; object-fit: cover; border-radius: 50%; box-shadow: 0 10px 30px rgba(0,0,0,0.3);">`;
            } else {
                heroDish.innerHTML = `<div style="width: 280px; height: 280px; background: rgba(255,255,255,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 4rem; backdrop-filter: blur(10px);">🍽️</div>`;
            }
            
            // Add floating animation
            heroDish.style.animation = 'float-gentle 6s ease-in-out infinite';
            
            // Update hero buy button functionality
            const heroBuyBtn = document.getElementById('heroBuyBtn');
            heroBuyBtn.onclick = function() {
                // Create and submit form for selected item
                const tempForm = document.createElement('form');
                tempForm.action = 'CartServlet';
                tempForm.method = 'post';
                
                const inputs = [
                    { name: 'id', value: id },
                    { name: 'name', value: name },
                    { name: 'price', value: price },
                    { name: 'quantity', value: '1' }
                ];
                
                inputs.forEach(input => {
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = 'hidden';
                    hiddenInput.name = input.name;
                    hiddenInput.value = input.value;
                    tempForm.appendChild(hiddenInput);
                });
                
                document.body.appendChild(tempForm);
                tempForm.submit();
            };
        }



        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // First check for seasonal promotions
            const hasSeasonalPromo = checkSeasonalPromotion();
            
            // Only auto-select first popular item if no seasonal promotion
            if (!hasSeasonalPromo) {
                const firstCard = document.querySelector('.popular-card');
                if (firstCard) {
                    setTimeout(() => {
                        firstCard.click();
                    }, 500);
                }
            }
        });

        // Category filtering
        const chips = document.querySelectorAll('.chip');
        const cards = document.querySelectorAll('.menu-card');

        chips.forEach(chip => {
            chip.addEventListener('click', () => {
                // Remove active class from all chips
                chips.forEach(c => c.classList.remove('active'));
                chip.classList.add('active');

                const category = chip.getAttribute('data-category');
                
                cards.forEach(card => {
                    if (category === '' || card.getAttribute('data-category') === category) {
                        card.style.display = 'block';
                        card.style.animation = 'fadeIn 0.5s ease-in';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });

        // Search functionality
        const searchBox = document.querySelector('.search-box');
        if (searchBox) {
            searchBox.addEventListener('input', (e) => {
                const searchTerm = e.target.value.toLowerCase();
                
                cards.forEach(card => {
                    const title = card.querySelector('h4').textContent.toLowerCase();
                    
                    if (title.includes(searchTerm)) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        }

        // Modal functions
        function openModal(id, name, price, imgUrl) {
            const modal = document.getElementById("itemModal");
            const body = document.getElementById("modalBody");

            const safeImg = imgUrl && imgUrl.trim() !== '' && imgUrl !== 'null' 
                            ? `<img src="${imgUrl}" alt="${name}">` 
                            : `<div style="width:100%; height:200px; display:flex; align-items:center; justify-content:center; font-size:3rem;">🍽️</div>`;

            body.innerHTML = `
                ${safeImg}
                <h2 style="margin:10px 0;">${name}</h2>
                <p><strong>Price:</strong> MMK ${price}</p>
                <form action="CartServlet" method="post">
                    <input type="hidden" name="id" value="${id}">
                    <input type="hidden" name="name" value="${name}">
                    <input type="hidden" name="price" value="${price}">
                    <input type="number" name="quantity" value="1" min="1" style="width:60px;">
                    <button type="submit" class="add-to-cart">🛒 Add to Cart</button>
                </form>
            `;

            modal.style.display = "block";
        }

        function closeModal() {
            document.getElementById("itemModal").style.display = "none";
        }

        window.onclick = function(event) {
            const modal = document.getElementById("itemModal");
            if (event.target == modal) {
                modal.style.display = "none";
            }
        };

        // Add promotional glow animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            @keyframes float-gentle {
                0%, 100% { transform: translateY(0px); }
                50% { transform: translateY(-10px); }
            }
            @keyframes promotional-glow {
                0% { box-shadow: 0 20px 40px rgba(0,0,0,0.4), 0 0 0 0 rgba(255, 107, 53, 0.4); }
                100% { box-shadow: 0 25px 50px rgba(0,0,0,0.6), 0 0 30px 10px rgba(255, 107, 53, 0.2); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>