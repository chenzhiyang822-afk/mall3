<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mall.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Product - Mall Admin</title>
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
            max-width: 800px;
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
        .btn-back {
            padding: 10px 20px;
            background: #f1f5f9;
            color: #64748b;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            background: #e2e8f0;
        }
        .form-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        }
        .form-group {
            margin-bottom: 24px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        .form-group label span {
            color: #dc2626;
        }
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #0f3460;
            box-shadow: 0 0 0 3px rgba(15, 52, 96, 0.1);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .error-msg {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #0f3460 0%, #1a1a2e 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(15, 52, 96, 0.3);
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
            <h1>Add Product</h1>
            <a href="${pageContext.request.contextPath}/admin/product?action=list" class="btn-back">Back to List</a>
        </div>
        
        <div class="form-container">
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-msg">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/admin/product?action=add" method="post">
                <div class="form-group">
                    <label for="name">Product Name <span>*</span></label>
                    <input type="text" id="name" name="name" 
                           value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>"
                           placeholder="Enter product name" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" 
                              placeholder="Enter product description"><%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %></textarea>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="price">Price <span>*</span></label>
                        <input type="number" id="price" name="price" step="0.01" min="0"
                               value="<%= request.getAttribute("price") != null ? request.getAttribute("price") : "" %>"
                               placeholder="0.00" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="stock">Stock</label>
                        <input type="number" id="stock" name="stock" min="0"
                               value="<%= request.getAttribute("stock") != null ? request.getAttribute("stock") : "0" %>"
                               placeholder="0">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="1" <%= "0".equals(request.getAttribute("status")) ? "" : "selected" %>>On Sale</option>
                        <option value="0" <%= "0".equals(request.getAttribute("status")) ? "selected" : "" %>>Off Sale</option>
                    </select>
                </div>
                
                <button type="submit" class="btn-submit">Add Product</button>
            </form>
        </div>
    </div>
</body>
</html>

