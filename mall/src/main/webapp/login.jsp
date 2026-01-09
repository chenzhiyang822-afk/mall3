<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Mall</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 400px;
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h1 {
            color: #1a1a2e;
            font-size: 28px;
            font-weight: 600;
        }
        .login-header p {
            color: #666;
            margin-top: 8px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        .form-group input:focus {
            outline: none;
            border-color: #0f3460;
            box-shadow: 0 0 0 3px rgba(15, 52, 96, 0.1);
        }
        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #0f3460 0%, #1a1a2e 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(15, 52, 96, 0.3);
        }
        .error-msg {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .success-msg {
            background: #dcfce7;
            color: #16a34a;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .register-link {
            text-align: center;
            margin-top: 24px;
            color: #666;
        }
        .register-link a {
            color: #0f3460;
            text-decoration: none;
            font-weight: 600;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Mall Login</h1>
            <p>Welcome back! Please login to your account.</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-msg">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" 
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                       placeholder="Enter your username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" 
                       placeholder="Enter your password" required>
            </div>
            
            <button type="submit" class="btn">Login</button>
        </form>
        
        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a>
        </div>
    </div>
</body>
</html>

