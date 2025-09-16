<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.CartItem" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="com.foodparadise.model.Order" %>
<%@ page import="com.foodparadise.model.MenuItem" %>
<%@ page import="com.foodparadise.dao.MenuDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if(cart == null) cart = new java.util.ArrayList<>();

    // Check if December discount is applicable
    boolean isDecemberDiscount = Order.isDecemberDiscountApplicable();
    double discountPercentage = Order.getDecemberDiscountPercentage();

    
    // Rainy season discount (April to October)
    java.time.LocalDate todayDate = java.time.LocalDate.now();
    boolean isRainyDiscount = todayDate.getMonthValue() >= 4 && todayDate.getMonthValue() <= 10;
    double rainyDiscountPercentage = 0.20;

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart — Food Paradise</title>
    <link rel="stylesheet" href="assets/cart.css?v=1.0">
   
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

<main class="container no-print">
    <h2>Items in Your Cart</h2>

    <% if(isDecemberDiscount) { %>
    <div class="december-discount-banner">
        <h3>🎄 December Special Offer! 🎄</h3>
        <p>Enjoy 10% OFF on all orders during December!</p>
    </div>
    <% } %>
    <% if(isRainyDiscount) { %>
<div class="december-discount-banner" style="background: linear-gradient(135deg, #17a2b8, #28a745);">
    <h3 style="color: white;">☔ Rainy Season Special! ☔</h3>
    <p style="color: white;">Enjoy 20% OFF on all orders during the rainy season!</p>
</div>
<% } %>


    <% if(cart.isEmpty()){ %>
    <p>Your cart is empty.</p>
    <% } else { %>
    <form id="cartForm" action="AddOrderServlet" method="post">
    <div class="cart-grid">
        <% 
        MenuDAO menuDao = new MenuDAO();

        for(int i=0; i<cart.size(); i++){
            CartItem item = cart.get(i);
            MenuItem menuItem = menuDao.getMenuItemById(item.getId());
    int stock = menuItem != null ? menuItem.getStock() : 0;
            int maxAllowed = Math.min(50, stock); // maximum allowed quantity
        %>
        <div class="cart-card" data-index="<%=i%>">
            <div class="cart-card-content">
                <h4><%= item.getName() %></h4>
                <p class="price">MMK<%= item.getPrice() %></p>
                <p>
                    Quantity:
                    <input type="number" class="quantity-input" 
                           name="quantity_<%=i%>" 
                           value="<%= Math.min(item.getQuantity(), maxAllowed) %>" 
                           min="1" 
                           max="<%= maxAllowed %>">
                    <input type="hidden" name="id_<%=i%>" value="<%= item.getId() %>">
                </p>
                <% if(item.getQuantity() > maxAllowed){ %>
    <div class="stock-warning">
        ⚠️ Maximum order for this item is <%= maxAllowed %>.
        <a href="menu.jsp" class="preorder-link">browse preorder page</a>
    </div>
<% } %>
            </div>
            <div class="cart-card-footer">
                <button type="button" class="remove-btn"
                        onclick="window.location='RemoveCartItemServlet?index=<%=i%>'">
                    Remove
                </button>
                <span class="subtotal">MMK<%= item.getPrice() * Math.min(item.getQuantity(), maxAllowed) %></span>
            </div>
        </div>
        <% } %>
    </div>

    <div class="discount-breakdown">
        <% if(isDecemberDiscount) { %>
        <div class="discount-row">
            <span>December Discount (10%):</span>
            <span class="discount-amount" id="decemberDiscountAmount">-MMK0.00</span>
        </div>
        <% } %>
        <% if(isRainyDiscount) { %>
        <div class="discount-row">
            <span>Rainy Season Discount (20%):</span>
            <span class="discount-amount" id="rainyDiscountAmount" style="color: #28a745;">-MMK0.00</span>
        </div>
        <% } %>
        <div class="discount-row total">
            <span>Total:</span>
            <span id="total">MMK0.00</span>
        </div>
    </div>

    <!-- Phone Number Field -->
    <div class="phone-field">
        <label for="phone">Phone Number (+959...):</label>
        <input type="tel" id="phone" name="phone" placeholder="+959XXXXXXXXX" pattern="\+959\d{7,9}" required>
    </div>

    <!-- Location Fields -->
    <div class="location-field">
        <label for="city">City:</label>
        <select id="city" name="city" required onchange="updateDeliveryFee()">
            <option value="">Select City</option>
            <option value="Yangon">Yangon</option>
            <option value="Mandalay">Mandalay</option>
            <option value="Taunggyi">Taunggyi</option>
            <option value="Naypyitaw">Naypyitaw</option>
        </select>
    </div>

    <div class="street-field" style="margin-top:10px;">
        <label for="street">Street Address:</label>
        <input type="text" id="street" name="street" placeholder="Enter street address" required>
    </div>

    <div class="delivery-fee" style="margin-top:10px;">
        <span>Delivery Fee: </span><span id="deliveryFeeDisplay">MMK0.00</span>
    </div>

    <div class="button-group">
        <input type="hidden" name="totalAmount" id="totalAmount" value="0">
        <input type="hidden" name="originalAmount" id="originalAmount" value="0">
        <input type="hidden" name="discountAmount" id="discountAmountHidden" value="0">
        <input type="hidden" name="isDecemberDiscount" value="<%= isDecemberDiscount %>">
        <input type="hidden" name="deliveryFee" id="deliveryFeeHidden" value="0">
        <button type="button" class="checkout-btn" id="checkoutBtn" disabled onclick="confirmKBZPayment()">Pay with KBZpay</button>
    </div>
</form>

    <% } %>
</main>

<!-- Receipt Confirmation Modal -->
<div id="receiptModal" class="modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
    <div class="modal-content" style="background:white; padding:20px; max-width:500px; width:90%; border-radius:10px; position:relative;">
        <h2>Confirm Your Order</h2>
        <div id="modalReceiptContent" style="max-height:400px; overflow-y:auto; margin:15px 0;">
            <!-- Receipt content will be injected here -->
        </div>
        <div style="display:flex; justify-content:flex-end; gap:10px;">
            <button onclick="cancelOrder()" style="padding:8px 15px;">Cancel</button>
            <button onclick="confirmOrder()" style="padding:8px 15px; background:#28a745; color:white; border:none; border-radius:5px;">Confirm</button>
        </div>
    </div>
</div>

<!-- Print Confirmation Modal -->
<div id="printModal" class="modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background: rgba(0,0,0,0.5); z-index:9999; align-items:center; justify-content:center;">
    <div class="modal-content" style="background:white; padding:20px; max-width:400px; width:90%; border-radius:10px; text-align:center;">
        <h2>Order Confirmation</h2>
        <p>Do you want to print or save your receipt?</p>
        <div style="display:flex; justify-content:center; gap:10px; margin-top:15px;">
            <button onclick="closePrintModal()" style="padding:8px 15px;">No</button>
            <button onclick="printConfirmedReceipt()" style="padding:8px 15px; background:#28a745; color:white; border:none; border-radius:5px;">Yes</button>
        </div>
    </div>
</div>


<!-- Hidden printable receipt -->
<div class="printable-receipt" id="printableReceipt">
    <div class="receipt-header">
        <h1>FOOD PARADISE</h1>
        <p>Order Receipt</p>
        <p id="receiptDate"></p>
        <p>Customer: <%= user.getName() %></p>
    </div>

    <div id="receiptItems">
        <!-- Items will be populated by JavaScript -->
    </div>

    <div class="receipt-separator"></div>

    <div id="receiptSubtotal" style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 5px;">
    <span>Subtotal:</span>
    <span id="receiptSubtotalAmount">MMK0.00</span>
</div>

    <% if(isDecemberDiscount) { %>
<div class="receipt-discount">
    <span>December Discount (10%):</span>
    <span id="receiptDecemberDiscountAmount">-MMK0.00</span>
</div>
<% } %>

<% if(isRainyDiscount) { %>
<div class="receipt-discount">
    <span>Rainy Season Discount (20%):</span>
    <span id="receiptRainyDiscountAmount">-MMK0.00</span>
</div>
<% } %>

    <div class="receipt-total">
    <span>TOTAL:</span>
    <span id="receiptTotal">MMK0.00</span>
</div>

    <div class="receipt-footer">
        <p>Thank you for your order!</p>
        <% if(isDecemberDiscount) { %>
        <p>🎄 December Special Discount Applied! 🎄</p>
        <% } %>
        <p>Phone: <span id="receiptPhone"></span></p>
        <p>Payment Method: KBZpay</p>
    </div>
</div>

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

<script>
const isDecemberDiscount = <%= isDecemberDiscount %>;
const discountPercentage = <%= discountPercentage %>;

// Rainy Season Discount
const today = new Date();
const utc = today.getTime() + today.getTimezoneOffset() * 60000;
const myanmarTime = new Date(utc + 6.5 * 60 * 60000); // Myanmar +6:30
const month = myanmarTime.getMonth() + 1;
const isRainyDiscount = month >= 4 && month <= 10;
const rainyDiscountPercentage = 0.20;

// Delivery Fee
let deliveryFee = 0;
function updateDeliveryFee() {
    const city = document.getElementById('city')?.value || '';
    switch(city) {
        case "Taunggyi": deliveryFee = 3000; break;
        case "Yangon":
        case "Mandalay":
        case "Naypyitaw": deliveryFee = 5000; break;
        default: deliveryFee = 0;
    }
    const feeDisplay = document.getElementById('deliveryFeeDisplay');
    if(feeDisplay) feeDisplay.textContent = 'MMK' + deliveryFee.toFixed(2);
    updateTotals();
}
// Transfer item to preorder cart
function transferToPreorder(itemId, itemName, itemPrice, currentQty) {
    // Confirm with user
    if (!confirm(`Transfer "${itemName}" (${currentQty} units) to preorder cart?`)) {
        return;
    }
    
    // Create form data to send to PreOrderCartServlet
    const formData = new FormData();
    formData.append('id', itemId);
    formData.append('name', itemName);
    formData.append('price', itemPrice);
    formData.append('quantity', currentQty);
    
    // Set default expected delivery date (3 days from now)
    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + 3);
    const dateString = futureDate.toISOString().split('T')[0]; // YYYY-MM-DD
    formData.append('expectedDeliveryDate', dateString);
    
    // Send to PreOrderCartServlet
    fetch('PreOrderCartServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) {
            // Remove item from regular cart via server call
            const cartIndex = getCartIndex(itemId);
            if (cartIndex >= 0) {
                window.location.href = `RemoveCartItemServlet?index=${cartIndex}`;
            }
        } else {
            alert('Failed to transfer item. Please try again.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error transferring item. Please try again.');
    });
}

// Helper function to find cart index by item ID
function getCartIndex(itemId) {
    const cartCards = document.querySelectorAll('.cart-card');
    for (let i = 0; i < cartCards.length; i++) {
        const hiddenId = cartCards[i].querySelector('input[name^="id_"]');
        if (hiddenId && hiddenId.value == itemId) {
            return i;
        }
    }
    return -1;
}
// Totals Calculation
function updateTotals() {
    let subtotal = 0;
    document.querySelectorAll('.cart-card').forEach(card => {
        const price = parseFloat(card.querySelector('.cart-card-content .price')?.textContent.replace('MMK','') || 0);
        const qty = parseInt(card.querySelector('.quantity-input')?.value || 1);
        const itemSubtotal = price * qty;
        const subtotalElem = card.querySelector('.subtotal');
        if(subtotalElem) subtotalElem.textContent = 'MMK' + itemSubtotal.toFixed(2);
        subtotal += itemSubtotal;
    });

    const decemberDiscountAmount = isDecemberDiscount ? subtotal * discountPercentage : 0;
    const rainyDiscountAmount = isRainyDiscount ? subtotal * rainyDiscountPercentage : 0;
    const totalDiscount = decemberDiscountAmount + rainyDiscountAmount;
    const finalTotal = subtotal - totalDiscount + deliveryFee;

    if(document.getElementById('decemberDiscountAmount')) {
    document.getElementById('decemberDiscountAmount').textContent = '-MMK' + decemberDiscountAmount.toFixed(2);
}
if(document.getElementById('rainyDiscountAmount')) {
    document.getElementById('rainyDiscountAmount').textContent = '-MMK' + rainyDiscountAmount.toFixed(2);
}
document.getElementById('total').textContent = 'MMK' + finalTotal.toFixed(2);

    if(document.getElementById('receiptDecemberDiscountAmount')) {
    document.getElementById('receiptDecemberDiscountAmount').textContent = '-MMK' + decemberDiscountAmount.toFixed(2);
}
if(document.getElementById('receiptRainyDiscountAmount')) {
    document.getElementById('receiptRainyDiscountAmount').textContent = '-MMK' + rainyDiscountAmount.toFixed(2);
}
document.getElementById('receiptTotal').textContent = 'MMK' + finalTotal.toFixed(2);

    document.getElementById('discountAmountHidden').value = totalDiscount.toFixed(2);
    document.getElementById('totalAmount').value = finalTotal.toFixed(2);
    document.getElementById('originalAmount').value = subtotal.toFixed(2);
    document.getElementById('deliveryFeeHidden').value = deliveryFee.toFixed(2);

}

// Update Receipt
function updateReceiptData() {
    const now = new Date();
    const phoneValue = document.getElementById('phone')?.value || 'Not provided';
    document.getElementById('receiptDate').textContent = now.toLocaleString();
    document.getElementById('receiptPhone').textContent = phoneValue;

    const receiptItemsContainer = document.getElementById('receiptItems');
    if(!receiptItemsContainer) return;
    receiptItemsContainer.innerHTML = '';

    let subtotal = 0;

    document.querySelectorAll('.cart-card').forEach(card => {
    const nameElement = card.querySelector('.cart-card-content h4');
    const name = nameElement ? nameElement.textContent.trim() : 'Unknown Item';

    const priceElement = card.querySelector('.cart-card-content .price');
    const priceText = priceElement ? priceElement.textContent.replace('MMK', '') : '0';
    const price = parseFloat(priceText);

    const qtyInput = card.querySelector('.quantity-input');
    const qty = qtyInput ? parseInt(qtyInput.value) : 1;

    const itemSubtotal = price * qty;
    subtotal += itemSubtotal;

    const itemDiv = document.createElement('div');
    itemDiv.className = 'receipt-item';
    itemDiv.innerHTML = '<span class="receipt-item-name">' + name + '</span><span class="receipt-item-qty">' + qty + 'x</span><span class="receipt-item-price">MMK' + itemSubtotal.toFixed(2) + '</span>';
    receiptItemsContainer.appendChild(itemDiv);
});

    // Delivery fee
    if(deliveryFee > 0){
        const deliveryDiv = document.createElement('div');
        deliveryDiv.className = 'receipt-item';
        deliveryDiv.innerHTML = `
            <span class="receipt-item-name">Delivery Fee</span>
            <span class="receipt-item-qty"></span>
            <span class="receipt-item-price">MMK${deliveryFee.toFixed(2)}</span>`;
        receiptItemsContainer.appendChild(deliveryDiv);
    }

    const decemberDiscountAmount = isDecemberDiscount ? subtotal * discountPercentage : 0;
    const rainyDiscountAmount = isRainyDiscount ? subtotal * rainyDiscountPercentage : 0;
    const totalDiscount = decemberDiscountAmount + rainyDiscountAmount;
    const finalTotal = subtotal - totalDiscount + deliveryFee;

    document.getElementById('receiptSubtotalAmount').textContent = 'MMK' + subtotal.toFixed(2);
    const receiptDiscountElem = document.getElementById('receiptDiscountAmount');
    if(receiptDiscountElem) receiptDiscountElem.textContent = '-MMK' + totalDiscount.toFixed(2);
    document.getElementById('receiptTotal').textContent = 'MMK' + finalTotal.toFixed(2);
}



// Payment & Printing
function confirmKBZPayment() { 
    updateReceiptData(); document.getElementById('printModal').style.display = 'flex'; }
function confirmOrder() { document.getElementById('receiptModal').style.display = 'none'; document.getElementById('cartForm').submit(); }
function cancelOrder() { document.getElementById('receiptModal').style.display = 'none'; }
function closePrintModal() { document.getElementById('printModal').style.display = 'none'; showConfirmOrderModal(); }
function printConfirmedReceipt() { 
    const printable = document.getElementById('printableReceipt'); 
    printable.style.display = 'block'; 
    window.print(); 
    setTimeout(() => { printable.style.display = 'none'; showConfirmOrderModal(); }, 1000); 
}
function showConfirmOrderModal() {
    const modalContent = document.getElementById('modalReceiptContent');
    const printable = document.getElementById('printableReceipt');
    const receiptModal = document.getElementById('receiptModal');
    if(modalContent && printable) modalContent.innerHTML = printable.innerHTML;
    if(receiptModal) receiptModal.style.display = 'flex';
}

// Phone Validation & Checkout Button
function validatePhone() { return /^\+959\d{7,9}$/.test(document.getElementById('phone')?.value || ''); }
function toggleCheckoutButton() {
    const phoneValid = validatePhone();
    const cityFilled = (document.getElementById('city')?.value || '') !== '';
    const streetFilled = (document.getElementById('street')?.value || '').trim() !== '';
    const checkoutBtn = document.getElementById('checkoutBtn');
    if(checkoutBtn) checkoutBtn.disabled = !(phoneValid && cityFilled && streetFilled);
}

window.addEventListener('DOMContentLoaded', () => {
    updateReceiptData();
});


// Event Listeners
document.querySelectorAll('.quantity-input').forEach(input => input.addEventListener('input', updateTotals));
document.getElementById('city')?.addEventListener('change', () => { updateDeliveryFee(); toggleCheckoutButton(); });
document.getElementById('street')?.addEventListener('input', toggleCheckoutButton);
document.getElementById('phone')?.addEventListener('input', toggleCheckoutButton);

// Initial Run
updateDeliveryFee();
updateTotals();
toggleCheckoutButton();
</script>





</body>
</html>