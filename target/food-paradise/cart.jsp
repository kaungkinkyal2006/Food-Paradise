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

        <div class="button-group">
            <button type="button" class="print-btn" onclick="printReceipt()">Print Receipt</button>
            <input type="hidden" name="totalAmount" id="totalAmount" value="0">
            <input type="hidden" name="originalAmount" id="originalAmount" value="0">
            <input type="hidden" name="discountAmount" id="discountAmountHidden" value="0">
            <input type="hidden" name="isDecemberDiscount" value="<%= isDecemberDiscount %>">
            <button type="submit" class="checkout-btn" id="checkoutBtn" disabled>Pay with KBZpay</button>
        </div>
    </form>
    <% } %>
</main>

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

    function updateTotals() {
        let subtotal = 0;

        document.querySelectorAll('.cart-card').forEach(card => {
            const priceElement = card.querySelector('.cart-card-content .price');
            const priceText = priceElement ? priceElement.textContent.replace('MMK', '') : '0';
            const price = parseFloat(priceText);

            const qtyInput = card.querySelector('.quantity-input');
            const qty = qtyInput ? parseInt(qtyInput.value) : 1;

            const itemSubtotal = price * qty;

            const subtotalElement = card.querySelector('.subtotal');
            if (subtotalElement) {
                subtotalElement.textContent = 'MMK' + itemSubtotal.toFixed(2);
            }

            subtotal += itemSubtotal;
        });

        // Calculate discount and final total
        let discountAmount = 0;
        let finalTotal = subtotal;

        if (isDecemberDiscount) {
            discountAmount = subtotal * discountPercentage;
            finalTotal = subtotal - discountAmount;

            document.getElementById('discountAmount').textContent = '-MMK' + discountAmount.toFixed(2);
            document.getElementById('discountAmountHidden').value = discountAmount.toFixed(2);
        }

        // Update display
        document.getElementById('subtotal').textContent = 'MMK' + subtotal.toFixed(2);
        document.getElementById('total').textContent = 'MMK' + finalTotal.toFixed(2);
        document.getElementById('totalAmount').value = finalTotal.toFixed(2);
        document.getElementById('originalAmount').value = subtotal.toFixed(2);
    }

    function validatePhone() {
        const phoneInput = document.getElementById('phone').value;
        const pattern = /^\+959\d{7,9}$/;
        return pattern.test(phoneInput);
    }

    function toggleCheckoutButton() {
        const btn = document.getElementById('checkoutBtn');
        btn.disabled = !validatePhone();
    }

    function printReceipt() {
        updateReceiptData();
        document.getElementById('printableReceipt').style.display = 'block';
        window.print();
        setTimeout(() => {
            document.getElementById('printableReceipt').style.display = 'none';
        }, 1000);
    }

    function updateReceiptData() {
        const now = new Date();
        document.getElementById('receiptDate').textContent = now.toLocaleString();

        const phone = document.getElementById('phone').value || 'Not provided';
        document.getElementById('receiptPhone').textContent = phone;

        const receiptItemsContainer = document.getElementById('receiptItems');
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

        // Update receipt totals
        document.getElementById('receiptSubtotalAmount').textContent = 'MMK' + subtotal.toFixed(2);

        let finalTotal = subtotal;
        if (isDecemberDiscount) {
            const discountAmount = subtotal * discountPercentage;
            finalTotal = subtotal - discountAmount;
            document.getElementById('receiptDiscountAmount').textContent = '-MMK' + discountAmount.toFixed(2);
        }

        document.getElementById('receiptTotal').textContent = 'MMK' + finalTotal.toFixed(2);
    }

    // Initialize totals and event listeners
    updateTotals();

    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('input', updateTotals);
    });

    document.getElementById('phone').addEventListener('input', toggleCheckoutButton);
</script>
</body>
</html>