package com.mall.servlet;

import com.mall.dao.UserDao;
import com.mall.entity.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 注册Servlet
 */
public class RegisterServlet extends HttpServlet {
    
    private UserDao userDao = new UserDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET请求跳转到注册页面
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 获取注册参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // 参数校验
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username is required");
            preserveFormData(request, username, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required");
            preserveFormData(request, username, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            preserveFormData(request, username, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            preserveFormData(request, username, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // 检查用户名是否已存在
        if (userDao.findByUsername(username.trim()) != null) {
            request.setAttribute("error", "Username already exists");
            preserveFormData(request, username, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // 创建用户对象
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setEmail(email != null ? email.trim() : null);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setRole(0);  // 默认普通用户
        
        // 保存用户
        if (userDao.insert(user)) {
            // 注册成功，跳转到登录页
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            // 注册失败
            request.setAttribute("error", "Registration failed. Please try again.");
            preserveFormData(request, username, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
    
    /**
     * 保留表单数据用于回显
     */
    private void preserveFormData(HttpServletRequest request, String username, String email, String phone) {
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }
}

