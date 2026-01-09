<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mall.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Mall</title>
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
        }
        .logo span {
            font-size: 14px;
            background: #e94560;
            padding: 4px 10px;
            border-radius: 4px;
            margin-left: 10px;
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
        .btn-logout {
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .main-content {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .welcome-section {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }
        .welcome-section h1 {
            color: #1a1a2e;
            font-size: 32px;
            margin-bottom: 8px;
        }
        .welcome-section p {
            color: #64748b;
            font-size: 16px;
        }
        .admin-badge {
            display: inline-block;
            padding: 4px 12px;
            background: #fef3c7;
            color: #d97706;
            border-radius: 20px;
            font-size: 14px;
            margin-top: 16px;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }
        .menu-card {
            background: white;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .menu-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
        }
        .menu-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 20px;
        }
        .menu-icon.products {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .menu-icon.orders {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .menu-card h3 {
            color: #1a1a2e;
            font-size: 20px;
            margin-bottom: 8px;
        }
        .menu-card p {
            color: #64748b;
            font-size: 14px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">Mall <span>Admin</span></div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/admin/index.jsp" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/product?action=list">Products</a>
        </div>
        <div class="user-info">
            <span>Welcome, <%= user.getUsername() %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </div>
    
    <div class="main-content">
        <div class="welcome-section">
            <h1>Admin Dashboard</h1>
            <p>Welcome to the administration panel. Manage your store from here.</p>
            <div class="admin-badge">Role: Administrator</div>
        </div>
        
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/admin/product?action=list" class="menu-card">
                <div class="menu-icon products">📦</div>
                <h3>Product Management</h3>
                <p>Add, edit, delete products. Manage stock and pricing.</p>
            </a>
            
            <a href="#" class="menu-card">
                <div class="menu-icon orders">📋</div>
                <h3>Order Management</h3>
                <p>View and manage customer orders. Update order status.</p>
            </a>
        </div>
    </div>
</body>
</html>
