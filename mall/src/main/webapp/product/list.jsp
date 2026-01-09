<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mall.entity.User" %>
<%@ page import="com.mall.entity.Product" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<Product> products = (List<Product>) request.getAttribute("products");
    String keyword = (String) request.getAttribute("keyword");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - Mall</title>
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
        .search-box {
            display: flex;
            gap: 10px;
        }
        .search-box input {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            width: 250px;
            font-size: 14px;
        }
        .search-box button {
            padding: 10px 20px;
            background: #e94560;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .search-box button:hover {
            background: #d63050;
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
            max-width: 1400px;
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
        .result-info {
            color: #64748b;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }
        .product-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
        }
        .product-image {
            height: 180px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
            font-weight: 700;
        }
        .product-info {
            padding: 20px;
        }
        .product-name {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 8px;
        }
        .product-desc {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 16px;
            line-height: 1.5;
            height: 42px;
            overflow: hidden;
        }
        .product-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .product-price {
            font-size: 22px;
            font-weight: 700;
            color: #e94560;
        }
        .product-stock {
            font-size: 13px;
            color: #64748b;
        }
        .product-stock.low {
            color: #dc2626;
        }
        .btn-detail {
            display: inline-block;
            padding: 10px 20px;
            background: linear-gradient(135deg, #0f3460 0%, #1a1a2e 100%);
            color: white;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-detail:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(15, 52, 96, 0.3);
        }
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }
        .empty-state h3 {
            color: #1a1a2e;
            margin-bottom: 8px;
            font-size: 24px;
        }
        .empty-state p {
            color: #64748b;
        }
    </style>
</head>
<body>
    <div class="header">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Mall</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/product?action=list" class="active">Products</a>
            <% if (user != null) { %>
                <a href="${pageContext.request.contextPath}/cart?action=list">Cart</a>
            <% } %>
        </div>
        <form action="${pageContext.request.contextPath}/product" method="get" class="search-box">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Search products..." value="<%= keyword != null ? keyword : "" %>">
            <button type="submit">Search</button>
        </form>
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
        <div class="page-header">
            <h1>
                <% if (keyword != null && !keyword.isEmpty()) { %>
                    Search Results for "<%= keyword %>"
                <% } else { %>
                    All Products
                <% } %>
            </h1>
            <% if (products != null) { %>
                <span class="result-info"><%= products.size() %> products found</span>
            <% } %>
        </div>
        
        <% if (products != null && !products.isEmpty()) { %>
            <div class="product-grid">
                <% for (Product product : products) { %>
                    <div class="product-card">
                        <div class="product-image">
                            <%= product.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="product-info">
                            <div class="product-name"><%= product.getName() %></div>
                            <div class="product-desc"><%= product.getDescription() != null ? product.getDescription() : "No description available" %></div>
                            <div class="product-footer">
                                <div>
                                    <div class="product-price">$<%= product.getPrice() %></div>
                                    <div class="product-stock <%= product.getStock() < 10 ? "low" : "" %>">
                                        Stock: <%= product.getStock() %>
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/product?action=detail&id=<%= product.getId() %>" class="btn-detail">View Details</a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <h3>No products found</h3>
                <p>
                    <% if (keyword != null && !keyword.isEmpty()) { %>
                        Try searching with different keywords.
                    <% } else { %>
                        Check back later for new products.
                    <% } %>
                </p>
            </div>
        <% } %>
    </div>
</body>
</html>
