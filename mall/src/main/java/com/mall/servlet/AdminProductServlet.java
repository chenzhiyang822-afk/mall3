package com.mall.servlet;

import com.mall.dao.ProductDao;
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
 * 管理员商品管理Servlet
 */
public class AdminProductServlet extends HttpServlet {
    
    private ProductDao productDao = new ProductDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查管理员权限
        if (!checkAdmin(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            case "status":
                updateStatus(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查管理员权限
        if (!checkAdmin(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "edit":
                editProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/product?action=list");
        }
    }
    
    /**
     * 检查管理员权限
     */
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return false;
        }
        return true;
    }
    
    /**
     * 商品列表
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDao.findAll();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/admin/product/list.jsp").forward(request, response);
    }
    
    /**
     * 显示添加表单
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/product/add.jsp").forward(request, response);
    }
    
    /**
     * 显示编辑表单
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Product product = productDao.findById(Integer.parseInt(idStr));
            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/admin/product/edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/product?action=list");
    }
    
    /**
     * 添加商品
     */
    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String statusStr = request.getParameter("status");
        
        // 参数校验
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Product name is required");
            request.getRequestDispatcher("/admin/product/add.jsp").forward(request, response);
            return;
        }
        
        if (priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("error", "Price is required");
            preserveFormData(request, name, description, priceStr, stockStr, statusStr);
            request.getRequestDispatcher("/admin/product/add.jsp").forward(request, response);
            return;
        }
        
        try {
            Product product = new Product();
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : null);
            product.setPrice(new BigDecimal(priceStr.trim()));
            product.setStock(stockStr != null && !stockStr.isEmpty() ? Integer.parseInt(stockStr) : 0);
            product.setStatus(statusStr != null ? Integer.parseInt(statusStr) : 1);
            
            if (productDao.insert(product)) {
                response.sendRedirect(request.getContextPath() + "/admin/product?action=list&success=added");
            } else {
                request.setAttribute("error", "Failed to add product");
                preserveFormData(request, name, description, priceStr, stockStr, statusStr);
                request.getRequestDispatcher("/admin/product/add.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format");
            preserveFormData(request, name, description, priceStr, stockStr, statusStr);
            request.getRequestDispatcher("/admin/product/add.jsp").forward(request, response);
        }
    }
    
    /**
     * 编辑商品
     */
    private void editProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");
        String statusStr = request.getParameter("status");
        
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/product?action=list");
            return;
        }
        
        // 参数校验
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Product name is required");
            Product product = productDao.findById(Integer.parseInt(idStr));
            request.setAttribute("product", product);
            request.getRequestDispatcher("/admin/product/edit.jsp").forward(request, response);
            return;
        }
        
        try {
            Product product = new Product();
            product.setId(Integer.parseInt(idStr));
            product.setName(name.trim());
            product.setDescription(description != null ? description.trim() : null);
            product.setPrice(new BigDecimal(priceStr.trim()));
            product.setStock(stockStr != null && !stockStr.isEmpty() ? Integer.parseInt(stockStr) : 0);
            product.setStatus(statusStr != null ? Integer.parseInt(statusStr) : 1);
            
            if (productDao.update(product)) {
                response.sendRedirect(request.getContextPath() + "/admin/product?action=list&success=updated");
            } else {
                request.setAttribute("error", "Failed to update product");
                request.setAttribute("product", product);
                request.getRequestDispatcher("/admin/product/edit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format");
            Product product = productDao.findById(Integer.parseInt(idStr));
            request.setAttribute("product", product);
            request.getRequestDispatcher("/admin/product/edit.jsp").forward(request, response);
        }
    }
    
    /**
     * 删除商品
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            productDao.delete(Integer.parseInt(idStr));
        }
        response.sendRedirect(request.getContextPath() + "/admin/product?action=list&success=deleted");
    }
    
    /**
     * 更新商品状态
     */
    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String statusStr = request.getParameter("status");
        if (idStr != null && !idStr.isEmpty() && statusStr != null) {
            productDao.updateStatus(Integer.parseInt(idStr), Integer.parseInt(statusStr));
        }
        response.sendRedirect(request.getContextPath() + "/admin/product?action=list");
    }
    
    /**
     * 保留表单数据
     */
    private void preserveFormData(HttpServletRequest request, String name, String description,
                                   String price, String stock, String status) {
        request.setAttribute("name", name);
        request.setAttribute("description", description);
        request.setAttribute("price", price);
        request.setAttribute("stock", stock);
        request.setAttribute("status", status);
    }
}

