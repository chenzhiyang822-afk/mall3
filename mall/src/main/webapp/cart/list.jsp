<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mall.entity.User" %>
<%@ page import="com.mall.entity.Cart" %>
<%@ page import="com.mall.entity.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Cart> cartList = (List<Cart>) request.getAttribute("cartList");
    BigDecimal totalAmount = (BigDecimal) request.getAttribute("totalAmount");
    if (totalAmount == null) {
        totalAmount = BigDecimal.ZERO;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - Mall</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #1a1a2e 0%, #0f3460 100%);
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .logo {
            color: white;
            font-size: 24px;
            font-weight: 700;
            text-decoration: none;
        }
        .nav-links {
            display: flex;
            gap: 20px;
            align-items: center;
        }
        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.1);
        }
        .nav-links a.active {
            background: rgba(255, 255, 255, 0.2);
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .user-info span {
            color: white;
        }
        .btn-auth {
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-auth:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .main-content {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .page-header h1 {
            color: #1a1a2e;
            font-size: 28px;
        }
        .btn-clear {
            padding: 10px 20px;
            background: #fee2e2;
            color: #dc2626;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-clear:hover {
            background: #fecaca;
        }
        .success-msg {
            background: #dcfce7;
            color: #16a34a;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .cart-container {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 30px;
        }
        .cart-items {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        .cart-item {
            display: flex;
            padding: 24px;
            border-bottom: 1px solid #f1f5f9;
            gap: 20px;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .item-image {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 32px;
            font-weight: 700;
            flex-shrink: 0;
        }
        .item-info {
            flex: 1;
        }
        .item-name {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 6px;
        }
        .item-name a {
            color: inherit;
            text-decoration: none;
        }
        .item-name a:hover {
            color: #0f3460;
        }
        .item-desc {
            font-size: 14px;
            color: #64748b;
            margin-bottom: 12px;
        }
        .item-price {
            font-size: 18px;
            font-weight: 600;
            color: #e94560;
        }
        .item-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 12px;
        }
        .quantity-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .quantity-input {
            display: flex;
            align-items: center;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
        }
        .quantity-input button {
            width: 32px;
            height: 32px;
            border: none;
            background: #f8fafc;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quantity-input button:hover {
            background: #e2e8f0;
        }
        .quantity-input input {
            width: 50px;
            height: 32px;
            border: none;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }
        .item-subtotal {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a2e;
        }
        .btn-remove {
            padding: 6px 12px;
            background: #fee2e2;
            color: #dc2626;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s ease;
        }
        .btn-remove:hover {
            background: #fecaca;
        }
        .cart-summary {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 30px;
        }
        .summary-title {
            font-size: 20px;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid #f1f5f9;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            color: #64748b;
        }
        .summary-row.total {
            font-size: 20px;
            font-weight: 700;
            color: #1a1a2e;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 2px solid #f1f5f9;
        }
        .summary-row.total .amount {
            color: #e94560;
        }
        .btn-checkout {
            display: block;
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #e94560 0%, #d63050 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            margin-top: 24px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(233, 69, 96, 0.3);
        }
        .btn-checkout:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        .btn-continue {
            display: block;
            text-align: center;
            margin-top: 16px;
            color: #0f3460;
            text-decoration: none;
            font-weight: 500;
        }
        .btn-continue:hover {
            text-decoration: underline;
        }
        .empty-cart {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 80px 40px;
            text-align: center;
            grid-column: 1 / -1;
        }
        .empty-cart h3 {
            color: #1a1a2e;
            font-size: 24px;
            margin-bottom: 12px;
        }
        .empty-cart p {
            color: #64748b;
            margin-bottom: 24px;
        }
        .btn-shop {
            display: inline-block;
            padding: 14px 32px;
            background: linear-gradient(135deg, #0f3460 0%, #1a1a2e 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-shop:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(15, 52, 96, 0.3);
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Mall</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/product?action=list">Products</a>
            <a href="${pageContext.request.contextPath}/cart?action=list" class="active">Cart</a>
        </div>
        <div class="user-info">
            <span>Welcome, <%= user.getUsername() %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-auth">Logout</a>
        </div>
    </div>
    
    <div class="main-content">
        <div class="page-header">
            <h1>Shopping Cart</h1>
            <% if (cartList != null && !cartList.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/cart?action=clear" class="btn-clear" 
                   onclick="return confirm('Are you sure you want to clear your cart?')">Clear Cart</a>
            <% } %>
        </div>
        
        <% if ("added".equals(request.getParameter("success"))) { %>
            <div class="success-msg">Product added to cart successfully!</div>
        <% } else if ("deleted".equals(request.getParameter("success"))) { %>
            <div class="success-msg">Item removed from cart.</div>
        <% } else if ("cleared".equals(request.getParameter("success"))) { %>
            <div class="success-msg">Cart cleared successfully!</div>
        <% } %>
        
        <div class="cart-container">
            <% if (cartList != null && !cartList.isEmpty()) { %>
                <div class="cart-items">
                    <% for (Cart cart : cartList) { 
                        Product product = cart.getProduct();
                        if (product != null) {
                    %>
                        <div class="cart-item">
                            <div class="item-image">
                                <%= product.getName().substring(0, 1).toUpperCase() %>
                            </div>
                            <div class="item-info">
                                <div class="item-name">
                                    <a href="${pageContext.request.contextPath}/product?action=detail&id=<%= product.getId() %>">
                                        <%= product.getName() %>
                                    </a>
                                </div>
                                <div class="item-desc">
                                    <%= product.getDescription() != null ? product.getDescription() : "" %>
                                </div>
                                <div class="item-price">$<%= product.getPrice() %></div>
                            </div>
                            <div class="item-actions">
                                <form action="${pageContext.request.contextPath}/cart?action=update" method="post" class="quantity-form">
                                    <input type="hidden" name="cartId" value="<%= cart.getId() %>">
                                    <div class="quantity-input">
                                        <button type="button" onclick="decreaseQty(this)">-</button>
                                        <input type="number" name="quantity" value="<%= cart.getQuantity() %>" min="1" max="<%= product.getStock() %>" onchange="this.form.submit()">
                                        <button type="button" onclick="increaseQty(this, <%= product.getStock() %>)">+</button>
                                    </div>
                                </form>
                                <div class="item-subtotal">Subtotal: $<%= cart.getSubtotal() %></div>
                                <a href="${pageContext.request.contextPath}/cart?action=delete&cartId=<%= cart.getId() %>" class="btn-remove">Remove</a>
                            </div>
                        </div>
                    <% } } %>
                </div>
                
                <div class="cart-summary">
                    <h2 class="summary-title">Order Summary</h2>
                    <div class="summary-row">
                        <span>Items (<%= cartList.size() %>)</span>
                        <span>$<%= totalAmount %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span>Free</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span class="amount">$<%= totalAmount %></span>
                    </div>
                    <button class="btn-checkout" onclick="checkout()">Proceed to Checkout</button>
                    <a href="${pageContext.request.contextPath}/product?action=list" class="btn-continue">Continue Shopping</a>
                </div>
            <% } else { %>
                <div class="empty-cart">
                    <h3>Your cart is empty</h3>
                    <p>Looks like you haven't added any items to your cart yet.</p>
                    <a href="${pageContext.request.contextPath}/product?action=list" class="btn-shop">Start Shopping</a>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        function decreaseQty(btn) {
            var input = btn.parentElement.querySelector('input[name="quantity"]');
            var value = parseInt(input.value);
            if (value > 1) {
                input.value = value - 1;
                btn.closest('form').submit();
            }
        }
        
        function increaseQty(btn, maxStock) {
            var input = btn.parentElement.querySelector('input[name="quantity"]');
            var value = parseInt(input.value);
            if (value < maxStock) {
                input.value = value + 1;
                btn.closest('form').submit();
            }
        }
        
        function checkout() {
            alert('Checkout feature will be implemented in the order module.');
        }
    </script>
</body>
</html>

