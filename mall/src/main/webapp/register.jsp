<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Mall</title>
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
            padding: 20px;
        }
        .register-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 450px;
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header h1 {
            color: #1a1a2e;
            font-size: 28px;
            font-weight: 600;
        }
        .register-header p {
            color: #666;
            margin-top: 8px;
        }
        .form-group {
            margin-bottom: 18px;
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
            margin-top: 10px;
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
        .login-link {
            text-align: center;
            margin-top: 24px;
            color: #666;
        }
        .login-link a {
            color: #0f3460;
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .hint {
            font-size: 12px;
            color: #888;
            margin-top: 4px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Create Account</h1>
            <p>Join us and start shopping today!</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-group">
                <label for="username">Username <span>*</span></label>
                <input type="text" id="username" name="username" 
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                       placeholder="Enter your username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password <span>*</span></label>
                <input type="password" id="password" name="password" 
                       placeholder="Enter your password" required>
                <div class="hint">Password must be at least 6 characters</div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password <span>*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" 
                       placeholder="Confirm your password" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" 
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                       placeholder="Enter your email (optional)">
            </div>
            
            <div class="form-group">
                <label for="phone">Phone</label>
                <input type="text" id="phone" name="phone" 
                       value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>"
                       placeholder="Enter your phone number (optional)">
            </div>
            
            <button type="submit" class="btn">Register</button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a>
        </div>
    </div>
</body>
</html>

