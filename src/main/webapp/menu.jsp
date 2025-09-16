<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="com.foodparadise.model.MenuItem" %>
<%@ page import="com.foodparadise.dao.MenuDAO" %>

<%
    MenuDAO menuDao = new MenuDAO();
    java.util.List<MenuItem> menuItems = menuDao.getAllMenuItems();
    request.setAttribute("menuItems", menuItems);

    java.util.List<MenuItem> popularItems = new java.util.ArrayList<>(menuItems);
    java.util.Collections.shuffle(popularItems);
    if (popularItems.size() > 4) {
        popularItems = popularItems.subList(0, 4);
    }
    request.setAttribute("popularItems", popularItems);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Paradise — Fresh Flavors Delivered</title>
    <link rel="stylesheet" href="assets/menu.css?v=2.0">
    <meta name="theme-color" content="#d84315" />
    <meta name="apple-mobile-web-app-status-bar-style" content="default" />
    
    <!-- Add food icons for floating animation -->
    <style>
        .food-floating {
            position: fixed;
            pointer-events: none;
            z-index: 1;
        }
    </style>
</head>
<body>
    <!-- Floating food icons animation -->
    <!-- <div class="food-icon food-floating" style="left: 5%; top: -50px; animation-delay: 0s;">🍕</div>
    <div class="food-icon food-floating" style="left: 15%; top: -50px; animation-delay: 2s;">🍔</div>
    <div class="food-icon food-floating" style="left: 25%; top: -50px; animation-delay: 4s;">🍜</div>
    <div class="food-icon food-floating" style="left: 35%; top: -50px; animation-delay: 1s;">🥗</div>
    <div class="food-icon food-floating" style="left: 45%; top: -50px; animation-delay: 6s;">🍰</div>
    <div class="food-icon food-floating" style="left: 55%; top: -50px; animation-delay: 3s;">🍕</div>
    <div class="food-icon food-floating" style="left: 65%; top: -50px; animation-delay: 5s;">🍔</div>
    <div class="food-icon food-floating" style="left: 75%; top: -50px; animation-delay: 7s;">🍜</div>
    <div class="food-icon food-floating" style="left: 85%; top: -50px; animation-delay: 2.5s;">🥗</div>
    <div class="food-icon food-floating" style="left: 95%; top: -50px; animation-delay: 8s;">🍰</div> -->

    <!-- Header -->
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
                <!-- Search Bar -->
                <input type="search" class="search-box" placeholder="Search delicious food...">
                
                <!-- Cart Button with Badge -->
                <button class="cart-icon" onclick="location.href='cart.jsp'">
                    🛒
                    
                </button>

                <!-- Login/Logout Button -->
                <%
                    User user = (User) session.getAttribute("user");
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
        <!-- Hero Section -->
        <section class="hero">
            <div class="hero-content">
                <span class="hero-badge" id="heroBadge">🔥 Chef's Special Today!</span>
                
                <h1 id="heroTitle">Fresh Flavors<br>Delivered to Your Door</h1>
                <p id="heroDescription">Experience authentic taste with our premium ingredients and chef-crafted recipes. Fast delivery, fresh ingredients, unforgettable flavors!</p>
                
                <div class="hero-price" id="heroPricing">
                    <span class="current-price" id="heroPrice">MMK 12,500</span>
                    <span class="original-price" id="heroOriginalPrice">MMK 18,000</span>
                </div>
                
                <div class="hero-buttons" id="heroButtons">
                    <button class="btn-primary" id="heroBuyBtn" onclick="document.getElementById('items').scrollIntoView({behavior: 'smooth'})">
                        🛒 Order Now
                    </button>
                    <button class="btn-secondary" id="heroMenuBtn" onclick="document.getElementById('items').scrollIntoView({behavior: 'smooth'})">
                        📖 Browse Menu
                    </button>
                </div>
            </div>
            
            <!-- Hero Image -->
            <div class="hero-image">
                <div class="hero-dish" id="heroDish">
                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=400&fit=crop" alt="Delicious Food" style="border-radius: 50%;">
                </div>
            </div>
        </section>
<!-- Pre-Order Notice Banner -->
<div class="preorder-top-banner">
    <div class="banner-content">
        <span class="banner-icon">⚠️</span>
        <p>
            If you want to order <strong>50 or more items</strong>, please <strong>pre-order at least 3 days in advance</strong>.
        </p>
    </div>
</div>



        <!-- Popular Menu Section -->
        <div class="popular-section">
            <h2 class="section-title">⭐ Popular Right Now</h2>
            <div class="popular-items">
                <c:forEach var="item" items="${popularItems}">
                    <div class="popular-card" onclick="selectItemFromRow('${item.id}', '${item.name}', '${item.description}', '${item.price}', '${item.imgUrl}', this)">
                        <c:choose>
                            <c:when test="${not empty item.imgUrl}">
                                <img src="${item.imgUrl}" alt="${item.name}">
                            </c:when>
                            <c:otherwise>
                                <div style="width:80px; height:80px; display:flex; align-items:center; justify-content:center; font-size:2.5rem; background: linear-gradient(135deg, #fff8e1, #ffecb3); border-radius:50%; color: #d84315;">🍽️</div>
                            </c:otherwise>
                        </c:choose>
                        <h4>${item.name}</h4>
                        <div class="price">💰 MMK ${item.price}</div>
                        <form id="cartForm${item.id}" method="post" onsubmit="return handleOrderType('${item.id}')">
                            <input type="hidden" name="id" value="${item.id}">
                            <input type="hidden" name="name" value="${item.name}">
                            <input type="hidden" name="price" value="${item.price}">
                            <div class="quantity-cart" style="display: flex; align-items: center; gap: 8px;">
                                <input type="number" name="quantity" value="1" min="1" style="width:45px; padding: 4px; border: 1px solid #e0e0e0; border-radius: 6px; text-align: center;">
                                <button type="submit" class="add-to-cart-small" title="Add to Cart">🛒</button>
                            </div>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Categories -->
        <div class="categories">
            <div class="category-section">
                <h3 class="category-title">🍽️ Food Categories</h3>
                <div class="chips">
                    <button type="button" class="chip active" data-category="">🌟 All Items</button>
                    <button type="button" class="chip" data-category="1">🍜 Myanmar Food</button>
                    <button type="button" class="chip" data-category="2">🌶️ Thai Food</button>
                    <button type="button" class="chip" data-category="3">🥢 Chinese Food</button>
                </div>
            </div>

            <div class="category-section">
                <h3 class="category-title">🥤 Beverages</h3>
                <div class="chips">
                    <button type="button" class="chip" data-category="4">☕ Coffee & Tea</button>
                    <button type="button" class="chip" data-category="5">🥤 Fresh Juices</button>
                    <button type="button" class="chip" data-category="6">🧋 Bubble Tea</button>
                </div>
            </div>
        </div>

        <!-- Menu Items Grid -->
        <div class="menu-section">
            <h2 class="section-title" style="margin-bottom: 1.5rem;">🍴 Full Menu</h2>
            <div class="menu-grid" id="items">
                <c:forEach var="item" items="${menuItems}">
                    <div class="menu-card fade-in" data-category="${item.categoryId}">
                        <c:choose>
                            <c:when test="${not empty item.imgUrl}">
                                <img src="${item.imgUrl}" alt="${item.name}" loading="lazy">
                            </c:when>
                            <c:otherwise>
                                <div style="width:120px; height:120px; display:flex; align-items:center; justify-content:center; font-size:3rem; background: linear-gradient(135deg, #fff8e1, #ffecb3); border-radius:16px; color: #d84315;">🍽️</div>
                            </c:otherwise>
                        </c:choose>
                        <div class="menu-card-content">
                            <h4>${item.name}</h4>
                            <p style="color: #8d6e63; font-size: 0.9rem; margin: 0.5rem 0; line-height: 1.4;">
                                ${not empty item.description ? item.description : 'Fresh and delicious, made with care'}
                            </p>
                            <div class="price">💰 MMK ${item.price}</div>
                            <div class="stock">📦 ${item.stock}</div>
                            <form id="cartForm${item.id}" method="post" onsubmit="return handleOrderType('${item.id}')">
    <input type="hidden" name="id" value="${item.id}">
    <input type="hidden" name="name" value="${item.name}">
    <input type="hidden" name="price" value="${item.price}">
    <input type="hidden" name="quantity" value="1" id="quantity${item.id}">
    
    <div class="quantity-add-section">
        <input type="number" value="1" min="1" onchange="document.getElementById('quantity${item.id}').value=this.value">
        <button type="submit" class="add-to-cart">🛒 Add to Cart</button>
    </div>
</form>

                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Delivery Info Banner -->
        <div style="background: linear-gradient(135deg, #e8f5e8, #f1f8e9); border-radius: 16px; padding: 2rem; margin: 3rem 0; text-align: center; border: 1px solid #c8e6c9;">
            <h3 style="color: #2e7d32; margin-bottom: 1rem; font-size: 1.4rem;">🚚 Fast & Fresh Delivery</h3>
            <p style="color: #5d4037; margin-bottom: 1rem;">Average delivery time: 25-35 minutes</p>
            <div style="display: flex; justify-content: center; gap: 2rem; flex-wrap: wrap; font-size: 0.9rem; color: #6d4c41;">
                <span>📱 Track your order</span>
                <span>🛡️ Safe packaging</span>
                <span>⭐ 4.8/5 customer rating</span>
            </div>
        </div>
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

    <!-- Modal -->
    <div id="itemModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <div id="modalBody"></div>
        </div>
    </div>

    <div id="orderTypeModal" class="order-type-modal">
    <div class="order-modal-content">
        <button class="modal-close" onclick="closeOrderTypeModal()">&times;</button>
        
        <div class="modal-header">
            <div class="modal-header-content">
                <span class="modal-icon">🛒</span>
                <h2 class="modal-title">Choose Order Type</h2>
                <p class="modal-subtitle">Select how you'd like to receive your delicious meal</p>
            </div>
        </div>
        
        <div class="modal-body">
            <div class="order-options">
                <!-- Normal Order Option -->
                <div class="order-option" onclick="selectOrderType('normal', this)" data-type="normal">
                    <div class="option-header">
                        <div class="option-icon">🚚</div>
                        <div class="option-info">
                            <h3>Order Now</h3>
                            <div class="option-price">Ready in 25-35 mins</div>
                        </div>
                        <div class="radio-custom"></div>
                    </div>
                    <div class="option-description">
                        Get your fresh meal prepared and delivered right away. Perfect for when you're hungry now!
                    </div>
                </div>
                
                <!-- Pre-Order Option -->
                <div class="order-option" onclick="selectOrderType('preorder', this)" data-type="preorder">
                    <div class="option-badge">Popular</div>
                    <div class="option-header">
                        <div class="option-icon">📅</div>
                        <div class="option-info">
                            <h3>Pre-Order</h3>
                            <div class="option-price">Schedule for later</div>
                        </div>
                        <div class="radio-custom"></div>
                    </div>
                    <div class="option-description">
                        Schedule your order for a specific time. Great for planning meals ahead or avoiding rush hours.
                    </div>
                </div>
            </div>
            
            <div class="modal-actions">
                <button class="modal-btn modal-btn-cancel" onclick="closeOrderTypeModal()">
                    Cancel
                </button>
                <button class="modal-btn modal-btn-confirm" id="confirmOrderBtn" onclick="confirmOrderType()" disabled>
                    Continue
                </button>
            </div>
        </div>
    </div>
</div>

    <script>

        let currentOrderForm = null;
let selectedOrderType = null;

function handleOrderType(itemId) {
    console.log("Clicked Add to Cart, showing modal for item", itemId);

    currentOrderForm = document.getElementById("cartForm" + itemId);
    selectedOrderType = null;

    // Reset modal
    document.querySelectorAll('.order-option').forEach(opt => opt.classList.remove('selected'));
    document.getElementById('confirmOrderBtn').disabled = true;

    showOrderTypeModal();
    return false; // stop default submit
}

function showOrderTypeModal() {
    const modal = document.getElementById('orderTypeModal');
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
}

function closeOrderTypeModal() {
    const modal = document.getElementById('orderTypeModal');
    modal.classList.remove('show');
    document.body.style.overflow = '';
}

function selectOrderType(type, element) {
    document.querySelectorAll('.order-option').forEach(option => {
        option.classList.remove('selected');
    });
    element.classList.add('selected');
    selectedOrderType = type;
    document.getElementById('confirmOrderBtn').disabled = false;
}

function confirmOrderType() {
    if (!currentOrderForm || !selectedOrderType) return;

    currentOrderForm.action = (selectedOrderType === 'preorder') ? "PreOrderCartServlet" : "CartServlet";

    closeOrderTypeModal();
    currentOrderForm.submit();
}

        
        // Store selected item data
        let selectedItem = null;
        let isSeasonalPromotion = false;

        // Function to check and set seasonal promotions
        function checkSeasonalPromotion() {
            const today = new Date();
            const month = today.getMonth() + 1;
            
            if (month >= 4 && month <= 10) {
                // Rainy season promotion
                document.getElementById('heroBadge').textContent = "🌧️ RAINY SEASON SPECIAL!";
                document.getElementById('heroTitle').innerHTML = "🔥 GET 20% OFF EVERYTHING! 🔥<br><span style='font-size: 1.6rem; color: #2e7d32;'>Beat the Rain with Great Food!</span>";
                document.getElementById('heroDescription').textContent = "Stay cozy indoors with amazing discounts! Hot, fresh meals delivered right to your door. Limited time monsoon offer!";
                document.getElementById('heroPrice').textContent = "UP TO 20% OFF";
                document.getElementById('heroOriginalPrice').textContent = "ALL MENU ITEMS";
                
                document.getElementById('heroDish').innerHTML = `
                    <div style="width: 300px; height: 300px; background: linear-gradient(135deg, #2196f3, #4caf50, #ff9800); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; font-size: 3rem; box-shadow: 0 15px 35px rgba(33, 150, 243, 0.3); animation: promotional-pulse 2s infinite;">
                        <div style="font-size: 4rem; margin-bottom: 8px;">🌧️</div>
                        <div style="font-size: 2.2rem; font-weight: 900; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);">20%</div>
                        <div style="font-size: 1.1rem; color: white; font-weight: 700;">OFF</div>
                    </div>`;
                isSeasonalPromotion = true;
                return true;
            } else if (month === 12) {
                // December promotion
                document.getElementById('heroBadge').textContent = "🎄 DECEMBER FEAST DEALS!";
                document.getElementById('heroTitle').innerHTML = "🎉 HOLIDAY SPECIALS! 🎉<br><span style='font-size: 1.6rem; color: #2e7d32;'>Festive Flavors & Great Prices!</span>";
                document.getElementById('heroDescription').textContent = "Celebrate the holidays with special festive menu items and incredible year-end discounts!";
                document.getElementById('heroPricing').style.display = 'none';
                
                document.getElementById('heroDish').innerHTML = `
                    <div style="width: 300px; height: 300px; background: linear-gradient(135deg, #e91e63, #4caf50, #ff5722); border-radius: 50%; display: flex; flex-direction: column; align-items: center; justify-content: center; font-size: 3rem; box-shadow: 0 15px 35px rgba(233, 30, 99, 0.3); animation: promotional-pulse 2s infinite;">
                        <div style="font-size: 4rem; margin-bottom: 8px;">🎄</div>
                        <div style="font-size: 1.8rem; font-weight: 900; color: white; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);">HOLIDAY</div>
                        <div style="font-size: 1.1rem; color: white; font-weight: 700;">SPECIALS</div>
                    </div>`;
                isSeasonalPromotion = true;
                return true;
            }
            
            isSeasonalPromotion = false;
            return false;
        }

        // Function to select item from popular section
        function selectItemFromRow(id, name, description, price, imgUrl, cardElement) {
            if (isSeasonalPromotion) {
                return;
            }
            
            // Remove previous selection
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
            document.getElementById('heroDescription').textContent = description || 'Fresh ingredients, authentic flavors, and chef-crafted perfection in every bite.';
            document.getElementById('heroPrice').textContent = `MMK ${price}`;
            
            // Calculate original price (30% higher for demo)
            const originalPrice = Math.round(parseFloat(price) * 1.3);
            document.getElementById('heroOriginalPrice').textContent = `MMK ${originalPrice}`;
            
            // Update hero image
            const heroDish = document.getElementById('heroDish');
            if (imgUrl && imgUrl.trim() !== '' && imgUrl !== 'null') {
                heroDish.innerHTML = `<img src="${imgUrl}" alt="${name}" style="width: 300px; height: 300px; object-fit: cover; border-radius: 50%; box-shadow: 0 15px 35px rgba(93, 64, 55, 0.2);">`;
            } else {
                heroDish.innerHTML = `<div style="width: 300px; height: 300px; background: linear-gradient(135deg, #fff8e1, #ffecb3); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 5rem; color: #d84315; box-shadow: 0 15px 35px rgba(93, 64, 55, 0.15);">🍽️</div>`;
            }
            
            // Update hero buy button functionality
            const heroBuyBtn = document.getElementById('heroBuyBtn');
            heroBuyBtn.onclick = function() {
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
            const hasSeasonalPromo = checkSeasonalPromotion();
            
            if (!hasSeasonalPromo) {
                const firstCard = document.querySelector('.popular-card');
                if (firstCard) {
                    setTimeout(() => {
                        firstCard.click();
                    }, 800);
                }
            }
            
            // Update cart badge (demo)
            updateCartBadge();
        });

        // Category filtering
        const chips = document.querySelectorAll('.chip');
        const cards = document.querySelectorAll('.menu-card');

        chips.forEach(chip => {
            chip.addEventListener('click', () => {
                chips.forEach(c => c.classList.remove('active'));
                chip.classList.add('active');

                const category = chip.getAttribute('data-category');
                
                cards.forEach(card => {
                    if (category === '' || card.getAttribute('data-category') === category) {
                        card.style.display = 'block';
                        card.classList.add('fade-in');
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
                        card.classList.add('fade-in');
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        }

        // Cart badge update function
        function updateCartBadge() {
            // This would typically get the actual cart count from server/localStorage
            const cartBadge = document.getElementById('cartBadge');
            const cartCount = 0; // Replace with actual cart count
            cartBadge.textContent = cartCount;
            cartBadge.style.display = cartCount > 0 ? 'flex' : 'none';
        }

        // Modal functions
        function openModal(id, name, price, imgUrl) {
            const modal = document.getElementById("itemModal");
            const body = document.getElementById("modalBody");

            const safeImg = imgUrl && imgUrl.trim() !== '' && imgUrl !== 'null' 
                            ? `<img src="${imgUrl}" alt="${name}" style="border-radius: 12px;">` 
                            : `<div style="width:100%; height:200px; display:flex; align-items:center; justify-content:center; font-size:4rem; background: linear-gradient(135deg, #fff8e1, #ffecb3); border-radius: 12px; color: #d84315;">🍽️</div>`;

            body.innerHTML = `
                ${safeImg}
                <h2 style="margin:15px 0; color: #3e2723;">${name}</h2>
                <p style="color: #2e7d32; font-size: 1.2rem; font-weight: 700;"><strong>💰 Price:</strong> MMK ${price}</p>
                <form action="CartServlet" method="post" style="margin-top: 20px;">
                    <input type="hidden" name="id" value="${id}">
                    <input type="hidden" name="name" value="${name}">
                    <input type="hidden" name="price" value="${price}">
                    <div style="display: flex; gap: 10px; align-items: center; margin-top: 15px;">
                        <label style="color: #5d4037; font-weight: 600;">Quantity:</label>
                        <input type="number" name="quantity" value="1" min="1" style="width:60px; padding: 8px; border: 2px solid #e0e0e0; border-radius: 8px;">
                        <button type="submit" class="add-to-cart" style="flex: 1;">🛒 Add to Cart</button>
                    </div>
                </form>
            `;

            modal.style.display = "flex";
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

        // Add animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes promotional-pulse {
                0%, 100% { transform: scale(1) rotate(0deg); }
                50% { transform: scale(1.05) rotate(2deg); }
            }
            
            .fade-in {
                animation: fadeInUp 0.6s ease-out;
            }
            
            @keyframes fadeInUp {
                from { 
                    opacity: 0; 
                    transform: translateY(30px); 
                }
                to { 
                    opacity: 1; 
                    transform: translateY(0); 
                }
            }
            
            .popular-card:hover, .menu-card:hover {
                transform: translateY(-8px) !important;
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>