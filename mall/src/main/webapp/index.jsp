<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mall.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - Mall</title>
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
        .hero {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            padding: 80px 40px;
            text-align: center;
            color: white;
        }
        .hero h1 {
            font-size: 48px;
            margin-bottom: 16px;
        }
        .hero p {
            font-size: 20px;
            opacity: 0.9;
            margin-bottom: 32px;
        }
        .btn-shop {
            display: inline-block;
            padding: 16px 40px;
            background: #e94560;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-shop:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(233, 69, 96, 0.3);
        }
        .main-content {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .section-title {
            text-align: center;
            margin-bottom: 40px;
        }
        .section-title h2 {
            color: #1a1a2e;
            font-size: 32px;
            margin-bottom: 8px;
        }
        .section-title p {
            color: #64748b;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
        }
        .feature-card {
            background: white;
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            text-align: center;
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
        }
        .feature-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
        }
        .feature-icon.browse {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .feature-icon.cart {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .feature-icon.order {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .feature-card h3 {
            color: #1a1a2e;
            font-size: 22px;
            margin-bottom: 12px;
        }
        .feature-card p {
            color: #64748b;
            line-height: 1.6;
        }
        .user-welcome {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            margin-bottom: 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .user-welcome h2 {
            color: #1a1a2e;
            font-size: 24px;
        }
        .user-welcome p {
            color: #64748b;
            margin-top: 4px;
        }
        .user-badge {
            display: inline-block;
            padding: 6px 16px;
            background: #dcfce7;
            color: #16a34a;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Mall</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp" class="active">Home</a>
            <a href="${pageContext.request.contextPath}/product?action=list">Products</a>
            <% if (user != null) { %>
                <a href="${pageContext.request.contextPath}/cart?action=list">Cart</a>
            <% } %>
            <% if (user != null && user.isAdmin()) { %>
                <a href="${pageContext.request.contextPath}/admin/index.jsp">Admin</a>
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
    
    <div class="hero">
        <h1>Welcome to Mall</h1>
        <p>Discover amazing products at great prices</p>
        <a href="${pageContext.request.contextPath}/product?action=list" class="btn-shop">Shop Now</a>
    </div>
    
    <div class="main-content">
        <% if (user != null) { %>
            <div class="user-welcome">
                <div>
                    <h2>Hello, <%= user.getUsername() %>!</h2>
                    <p>Welcome back to Mall. Start shopping today!</p>
                </div>
                <span class="user-badge"><%= user.isAdmin() ? "Administrator" : "Customer" %></span>
            </div>
        <% } %>
        
        <div class="section-title">
            <h2>Why Shop With Us</h2>
            <p>Experience the best online shopping</p>
        </div>
        
        <div class="features">
            <a href="${pageContext.request.contextPath}/product?action=list" class="feature-card" style="text-decoration: none;">
                <div class="feature-icon browse">🛍️</div>
                <h3>Browse Products</h3>
                <p>Explore our wide range of products. Find exactly what you need with our easy search.</p>
            </a>
            
            <a href="${pageContext.request.contextPath}/cart?action=list" class="feature-card" style="text-decoration: none;">
                <div class="feature-icon cart">🛒</div>
                <h3>Easy Cart</h3>
                <p>Add items to your cart and manage your selections before checkout.</p>
            </a>
            
            <div class="feature-card">
                <div class="feature-icon order">📦</div>
                <h3>Fast Orders</h3>
                <p>Quick and secure checkout process. Track your orders easily.</p>
            </div>
        </div>
    </div>
</body>
</html>
