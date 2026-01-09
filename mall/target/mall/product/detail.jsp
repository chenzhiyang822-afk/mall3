<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mall.entity.User" %>
<%@ page import="com.mall.entity.Product" %>
<%
    User user = (User) session.getAttribute("user");
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/product?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= product.getName() %> - Mall</title>
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
        .breadcrumb {
            margin-bottom: 24px;
        }
        .breadcrumb a {
            color: #64748b;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            color: #0f3460;
        }
        .breadcrumb span {
            color: #64748b;
            margin: 0 8px;
        }
        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        .product-image {
            height: 500px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 120px;
            font-weight: 700;
        }
        .product-info {
            padding: 40px 40px 40px 0;
            display: flex;
            flex-direction: column;
        }
        .product-name {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 16px;
        }
        .product-price {
            font-size: 36px;
            font-weight: 700;
            color: #e94560;
            margin-bottom: 24px;
        }
        .product-meta {
            display: flex;
            gap: 24px;
            margin-bottom: 24px;
            padding-bottom: 24px;
            border-bottom: 1px solid #f1f5f9;
        }
        .meta-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .meta-label {
            font-size: 13px;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .meta-value {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a2e;
        }
        .meta-value.low {
            color: #dc2626;
        }
        .meta-value.in-stock {
            color: #16a34a;
        }
        .product-desc {
            flex: 1;
            margin-bottom: 32px;
        }
        .product-desc h3 {
            color: #1a1a2e;
            font-size: 18px;
            margin-bottom: 12px;
        }
        .product-desc p {
            color: #64748b;
            line-height: 1.8;
        }
        .add-to-cart-form {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .quantity-selector {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .quantity-selector label {
            font-weight: 500;
            color: #333;
        }
        .quantity-input {
            display: flex;
            align-items: center;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
        }
        .quantity-input button {
            width: 40px;
            height: 40px;
            border: none;
            background: #f8fafc;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .quantity-input button:hover {
            background: #e2e8f0;
        }
        .quantity-input input {
            width: 60px;
            height: 40px;
            border: none;
            text-align: center;
            font-size: 16px;
            font-weight: 500;
        }
        .btn-cart {
            padding: 16px 32px;
            background: linear-gradient(135deg, #e94560 0%, #d63050 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-cart:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(233, 69, 96, 0.3);
        }
        .btn-cart:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        .login-hint {
            margin-top: 16px;
            color: #64748b;
            font-size: 14px;
        }
        .login-hint a {
            color: #0f3460;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Mall</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/product?action=list">Products</a>
            <% if (user != null) { %>
                <a href="${pageContext.request.contextPath}/cart?action=list">Cart</a>
            <% } %>
        </div>
        <div class="user-info">
            <% if (user != null) { %>
                <span>Welcome, <%= user.getUsername() %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-auth">Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-auth">Login</a>
            <% } %>
        </div>
    </div>
    
    <div class="main-content">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <span>/</span>
            <a href="${pageContext.request.contextPath}/product?action=list">Products</a>
            <span>/</span>
            <%= product.getName() %>
        </div>
        
        <div class="product-detail">
            <div class="product-image">
                <%= product.getName().substring(0, 1).toUpperCase() %>
            </div>
            <div class="product-info">
                <h1 class="product-name"><%= product.getName() %></h1>
                <div class="product-price">$<%= product.getPrice() %></div>
                
                <div class="product-meta">
                    <div class="meta-item">
                        <span class="meta-label">Stock</span>
                        <span class="meta-value <%= product.getStock() < 10 ? "low" : "in-stock" %>">
                            <%= product.getStock() > 0 ? product.getStock() + " available" : "Out of stock" %>
                        </span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Status</span>
                        <span class="meta-value in-stock">In Stock</span>
                    </div>
                </div>
                
                <div class="product-desc">
                    <h3>Description</h3>
                    <p><%= product.getDescription() != null ? product.getDescription() : "No description available for this product." %></p>
                </div>
                
                <form action="${pageContext.request.contextPath}/cart" method="post" class="add-to-cart-form">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                    
                    <div class="quantity-selector">
                        <label>Quantity:</label>
                        <div class="quantity-input">
                            <button type="button" onclick="decreaseQty()">-</button>
                            <input type="number" id="quantity" name="quantity" value="1" min="1" max="<%= product.getStock() %>">
                            <button type="button" onclick="increaseQty()">+</button>
                        </div>
                    </div>
                    
                    <% if (user != null) { %>
                        <button type="submit" class="btn-cart" <%= product.getStock() <= 0 ? "disabled" : "" %>>
                            <%= product.getStock() > 0 ? "Add to Cart" : "Out of Stock" %>
                        </button>
                    <% } else { %>
                        <button type="button" class="btn-cart" onclick="window.location.href='${pageContext.request.contextPath}/login.jsp'">
                            Login to Add to Cart
                        </button>
                        <div class="login-hint">
                            Please <a href="${pageContext.request.contextPath}/login.jsp">login</a> to add items to your cart.
                        </div>
                    <% } %>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        var maxStock = <%= product.getStock() %>;
        
        function decreaseQty() {
            var input = document.getElementById('quantity');
            var value = parseInt(input.value);
            if (value > 1) {
                input.value = value - 1;
            }
        }
        
        function increaseQty() {
            var input = document.getElementById('quantity');
            var value = parseInt(input.value);
            if (value < maxStock) {
                input.value = value + 1;
            }
        }
    </script>
</body>
</html>
