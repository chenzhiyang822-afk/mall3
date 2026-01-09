<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mall.entity.User" %>
<%@ page import="com.mall.entity.Product" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Management - Mall Admin</title>
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
        .btn-add {
            padding: 12px 24px;
            background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
            color: white;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(22, 163, 74, 0.3);
        }
        .success-msg {
            background: #dcfce7;
            color: #16a34a;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 16px 20px;
            text-align: left;
        }
        th {
            background: #f8fafc;
            color: #64748b;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        tr {
            border-bottom: 1px solid #f1f5f9;
        }
        tr:last-child {
            border-bottom: none;
        }
        tr:hover {
            background: #f8fafc;
        }
        .product-name {
            font-weight: 600;
            color: #1a1a2e;
        }
        .product-desc {
            color: #64748b;
            font-size: 13px;
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .price {
            font-weight: 600;
            color: #e94560;
        }
        .stock {
            font-weight: 500;
        }
        .stock.low {
            color: #dc2626;
        }
        .status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }
        .status.on-sale {
            background: #dcfce7;
            color: #16a34a;
        }
        .status.off-sale {
            background: #fee2e2;
            color: #dc2626;
        }
        .actions {
            display: flex;
            gap: 8px;
        }
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-edit {
            background: #dbeafe;
            color: #2563eb;
        }
        .btn-edit:hover {
            background: #bfdbfe;
        }
        .btn-status {
            background: #fef3c7;
            color: #d97706;
        }
        .btn-status:hover {
            background: #fde68a;
        }
        .btn-delete {
            background: #fee2e2;
            color: #dc2626;
        }
        .btn-delete:hover {
            background: #fecaca;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }
        .empty-state h3 {
            margin-bottom: 8px;
            color: #1a1a2e;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">Mall <span>Admin</span></div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/admin/index.jsp">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/product?action=list" class="active">Products</a>
        </div>
        <div class="user-info">
            <span>Welcome, <%= user.getUsername() %></span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
        </div>
    </div>
    
    <div class="main-content">
        <div class="page-header">
            <h1>Product Management</h1>
            <a href="${pageContext.request.contextPath}/admin/product?action=add" class="btn-add">+ Add Product</a>
        </div>
        
        <% if ("added".equals(request.getParameter("success"))) { %>
            <div class="success-msg">Product added successfully!</div>
        <% } else if ("updated".equals(request.getParameter("success"))) { %>
            <div class="success-msg">Product updated successfully!</div>
        <% } else if ("deleted".equals(request.getParameter("success"))) { %>
            <div class="success-msg">Product deleted successfully!</div>
        <% } %>
        
        <div class="table-container">
            <% if (products != null && !products.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Product</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Product product : products) { %>
                            <tr>
                                <td><%= product.getId() %></td>
                                <td>
                                    <div class="product-name"><%= product.getName() %></div>
                                    <div class="product-desc"><%= product.getDescription() != null ? product.getDescription() : "" %></div>
                                </td>
                                <td class="price">$<%= product.getPrice() %></td>
                                <td class="stock <%= product.getStock() < 10 ? "low" : "" %>"><%= product.getStock() %></td>
                                <td>
                                    <span class="status <%= product.isOnSale() ? "on-sale" : "off-sale" %>">
                                        <%= product.isOnSale() ? "On Sale" : "Off Sale" %>
                                    </span>
                                </td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/product?action=edit&id=<%= product.getId() %>" class="btn-action btn-edit">Edit</a>
                                    <a href="${pageContext.request.contextPath}/admin/product?action=status&id=<%= product.getId() %>&status=<%= product.isOnSale() ? 0 : 1 %>" class="btn-action btn-status">
                                        <%= product.isOnSale() ? "Off Sale" : "On Sale" %>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/product?action=delete&id=<%= product.getId() %>" class="btn-action btn-delete" onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <h3>No products found</h3>
                    <p>Click "Add Product" to create your first product.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>

