package com.mall.servlet;

import com.mall.dao.UserDao;
import com.mall.entity.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 登录Servlet
 */
public class LoginServlet extends HttpServlet {
    
    private UserDao userDao = new UserDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET请求跳转到登录页面
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 获取登录参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 参数校验
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // 验证用户
        User user = userDao.findByUsernameAndPassword(username.trim(), password);
        
        if (user != null) {
            // 登录成功，保存用户到session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // 根据角色跳转到不同页面
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            // 登录失败
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}

