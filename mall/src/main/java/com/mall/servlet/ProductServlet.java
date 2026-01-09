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
 * 商品Servlet(用户浏览)
 */
public class ProductServlet extends HttpServlet {
    
    private ProductDao productDao = new ProductDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }
    
    /**
     * 商品列表(上架商品)
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDao.findOnSale();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/product/list.jsp").forward(request, response);
    }
    
    /**
     * 商品详情
     */
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            Product product = productDao.findById(Integer.parseInt(idStr));
            if (product != null && product.isOnSale()) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/product/detail.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/product?action=list");
    }
    
    /**
     * 搜索商品
     */
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Product> products;
        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDao.search(keyword.trim());
            request.setAttribute("keyword", keyword);
        } else {
            products = productDao.findOnSale();
        }
        request.setAttribute("products", products);
        request.getRequestDispatcher("/product/list.jsp").forward(request, response);
    }
}

