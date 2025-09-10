<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.foodparadise.model.CartItem" %>
<%@ page import="com.foodparadise.model.User" %>
<%@ page import="com.foodparadise.model.Order" %>
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
    <link rel="stylesheet" href="assets/cart.css">
    <style>
        .phone-field { margin: 15px 0; }
        .phone-field input { padding: 8px; width: 200px; }
        .checkout-btn:disabled { background-color: #ccc; cursor: not-allowed; }

        .print-btn {
            background: #28a745;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin-left: 1rem;
            transition: all 0.3s ease;
        }

        .print-btn:hover {
            background: #218838;
        }

        .button-group {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 1rem;
        }

        /* December discount styles */
        .december-discount-banner {
            background: linear-gradient(135deg, #dc3545, #28a745);
            color: white;
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            animation: pulse 2s infinite;
        }

        .december-discount-banner h3 {
            margin: 0 0 0.5rem 0;
            font-size: 1.2rem;
        }

        .december-discount-banner p {
            margin: 0;
            font-size: 0.9rem;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.02); }
            100% { transform: scale(1); }
        }

        .discount-breakdown {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            margin: 1rem 0;
        }

        .discount-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }

        .discount-row.total {
            border-top: 2px solid #333;
            padding-top: 0.5rem;
            font-weight: bold;
            font-size: 1.1rem;
        }

        .discount-amount {
            color: #28a745;
            font-weight: bold;
        }

        /* Print styles - only show receipt content when printing */
        @media print {
            body * {
                visibility: hidden;
            }

            .printable-receipt, .printable-receipt * {
                visibility: visible;
            }

            .printable-receipt {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                background: white;
                padding: 20px;
            }

            .no-print {
                display: none !important;
            }
        }

        /* Receipt styling */
        .printable-receipt {
            display: none;
            max-width: 400px;
            margin: 0 auto;
            font-family: 'Courier New', monospace;
            line-height: 1.4;
        }

        .receipt-header {
            text-align: center;
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }

        .receipt-header h1 {
            font-size: 18px;
            margin: 0;
        }

        .receipt-header p {
            margin: 5px 0;
            font-size: 12px;
        }

        .receipt-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
            font-size: 12px;
        }

        .receipt-item-name {
            flex: 1;
        }

        .receipt-item-qty {
            width: 30px;
            text-align: center;
        }

        .receipt-item-price {
            width: 60px;
            text-align: right;
        }

        .receipt-separator {
            border-top: 1px dashed #333;
            margin: 10px 0;
        }

        .receipt-discount {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #28a745;
            margin-bottom: 5px;
        }

        .receipt-total {
            display: flex;
            justify-content: space-between;
            font-weight: bold;
            font-size: 14px;
            border-top: 2px solid #333;
            padding-top: 5px;
            margin-top: 10px;
        }

        .receipt-footer {
            text-align: center;
            margin-top: 15px;
            font-size: 10px;
            border-top: 1px solid #333;
            padding-top: 10px;
        }
    </style>
</head>
<body>
<header class="topbar no-print">
    <h1>Your Cart</h1>
    <nav>
        <a href="menu.jsp">Menu</a>
        <a href="cart.jsp">Cart</a>
        <a href="myorders.jsp">My Orders</a>
        <a href="logout">Logout</a>
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
    <h3>☔ Rainy Season Special! ☔</h3>
    <p>Enjoy 20% OFF on all orders during the rainy season!</p>
</div>
<% } %>


    <% if(cart.isEmpty()){ %>
    <p>Your cart is empty.</p>
    <% } else { %>
    <form id="cartForm" action="AddOrderServlet" method="post">
        <div class="cart-grid">
            <% for(int i=0; i<cart.size(); i++){
                CartItem item = cart.get(i);
            %>
            <div class="cart-card" data-index="<%=i%>">
                <div class="cart-card-content">
                    <h4><%= item.getName() %></h4>
                    <p class="price">MMK<%= item.getPrice() %></p>
                    <p>
                        Quantity:
                        <input type="number" class="quantity-input" name="quantity_<%=i%>" value="<%= item.getQuantity() %>" min="1">
                        <input type="hidden" name="id_<%=i%>" value="<%= item.getId() %>">
                    </p>
                </div>
                <div class="cart-card-footer">
                    <button type="button" class="remove-btn"
                            onclick="window.location='RemoveCartItemServlet?index=<%=i%>'">
                        Remove
                    </button>
                    <span class="subtotal">MMK<%= item.getPrice()*item.getQuantity() %></span>
                </div>
            </div>
            <% } %>
        </div>

        <div class="discount-breakdown">
            <div class="discount-row">
                <span>Subtotal:</span>
                <span id="subtotal">MMK0.00</span>
            </div>
            <% if(isDecemberDiscount) { %>
            <div class="discount-row">
                <span>December Discount (10%):</span>
                <span class="discount-amount" id="discountAmount">-MMK0.00</span>
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
        <span id="receiptDiscountAmount">-MMK0.00</span>
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

    document.getElementById('subtotal').textContent = 'MMK' + subtotal.toFixed(2);
    const discountElem = document.getElementById('discountAmount');
    if(discountElem) discountElem.textContent = '-MMK' + totalDiscount.toFixed(2);
    document.getElementById('total').textContent = 'MMK' + finalTotal.toFixed(2);

    document.getElementById('discountAmountHidden').value = totalDiscount.toFixed(2);
    document.getElementById('totalAmount').value = finalTotal.toFixed(2);
    document.getElementById('originalAmount').value = subtotal.toFixed(2);
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