package com.mall.servlet;

import com.mall.dao.CartDao;
import com.mall.dao.ProductDao;
import com.mall.entity.Cart;
import com.mall.entity.Product;
import com.mall.entity.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * 购物车Servlet
 */
public class CartServlet extends HttpServlet {
    
    private CartDao cartDao = new CartDao();
    private ProductDao productDao = new ProductDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查用户登录
        User user = checkLogin(request, response);
        if (user == null) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listCart(request, response, user);
                break;
            case "delete":
                deleteCartItem(request, response, user);
                break;
            case "clear":
                clearCart(request, response, user);
                break;
            default:
                listCart(request, response, user);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查用户登录
        User user = checkLogin(request, response);
        if (user == null) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }
        
        switch (action) {
            case "add":
                addToCart(request, response, user);
                break;
            case "update":
                updateQuantity(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart?action=list");
        }
    }
    
    /**
     * 检查用户登录
     */
    private User checkLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return null;
        }
        return user;
    }
    
    /**
     * 显示购物车列表
     */
    private void listCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Cart> cartList = cartDao.findByUserId(user.getId());
        
        // 计算总金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Cart cart : cartList) {
            totalAmount = totalAmount.add(cart.getSubtotal());
        }
        
        request.setAttribute("cartList", cartList);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/cart/list.jsp").forward(request, response);
    }
    
    /**
     * 添加商品到购物车
     */
    private void addToCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException, ServletException {
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        
        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }
        
        int productId = Integer.parseInt(productIdStr);
        int quantity = 1;
        if (quantityStr != null && !quantityStr.isEmpty()) {
            quantity = Integer.parseInt(quantityStr);
        }
        
        // 检查商品是否存在且上架
        Product product = productDao.findById(productId);
        if (product == null || !product.isOnSale()) {
            request.setAttribute("error", "Product not available");
            response.sendRedirect(request.getContextPath() + "/product?action=list");
            return;
        }
        
        // 检查库存
        if (quantity > product.getStock()) {
            quantity = product.getStock();
        }
        
        // 检查购物车中是否已有该商品
        Cart existingCart = cartDao.findByUserIdAndProductId(user.getId(), productId);
        
        if (existingCart != null) {
            // 更新数量
            int newQuantity = existingCart.getQuantity() + quantity;
            if (newQuantity > product.getStock()) {
                newQuantity = product.getStock();
            }
            cartDao.updateQuantity(existingCart.getId(), newQuantity);
        } else {
            // 新增购物车项
            Cart cart = new Cart();
            cart.setUserId(user.getId());
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            cartDao.insert(cart);
        }
        
        response.sendRedirect(request.getContextPath() + "/cart?action=list&success=added");
    }
    
    /**
     * 更新购物车商品数量
     */
    private void updateQuantity(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String cartIdStr = request.getParameter("cartId");
        String quantityStr = request.getParameter("quantity");
        
        if (cartIdStr == null || quantityStr == null) {
            response.sendRedirect(request.getContextPath() + "/cart?action=list");
            return;
        }
        
        int cartId = Integer.parseInt(cartIdStr);
        int quantity = Integer.parseInt(quantityStr);
        
        // 验证购物车项属于当前用户
        Cart cart = cartDao.findById(cartId);
        if (cart == null || !cart.getUserId().equals(user.getId())) {
            response.sendRedirect(request.getContextPath() + "/cart?action=list");
            return;
        }
        
        // 检查库存
        Product product = productDao.findById(cart.getProductId());
        if (product != null && quantity > product.getStock()) {
            quantity = product.getStock();
        }
        
        if (quantity <= 0) {
            cartDao.delete(cartId);
        } else {
            cartDao.updateQuantity(cartId, quantity);
        }
        
        response.sendRedirect(request.getContextPath() + "/cart?action=list");
    }
    
    /**
     * 删除购物车项
     */
    private void deleteCartItem(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        String cartIdStr = request.getParameter("cartId");
        
        if (cartIdStr != null && !cartIdStr.isEmpty()) {
            int cartId = Integer.parseInt(cartIdStr);
            // 验证购物车项属于当前用户
            Cart cart = cartDao.findById(cartId);
            if (cart != null && cart.getUserId().equals(user.getId())) {
                cartDao.delete(cartId);
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/cart?action=list&success=deleted");
    }
    
    /**
     * 清空购物车
     */
    private void clearCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        cartDao.clearByUserId(user.getId());
        response.sendRedirect(request.getContextPath() + "/cart?action=list&success=cleared");
    }
}

