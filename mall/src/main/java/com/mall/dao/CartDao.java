package com.mall.dao;

import com.mall.entity.Cart;
import com.mall.entity.Product;
import com.mall.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 购物车数据访问层
 */
public class CartDao {
    
    /**
     * 查询用户的购物车列表(包含商品信息)
     */
    public List<Cart> findByUserId(Integer userId) {
        String sql = "SELECT c.*, p.name as product_name, p.description as product_description, " +
                     "p.price as product_price, p.stock as product_stock, p.status as product_status " +
                     "FROM cart c " +
                     "LEFT JOIN product p ON c.product_id = p.id " +
                     "WHERE c.user_id = ? " +
                     "ORDER BY c.create_time DESC";
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Cart> list = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Cart cart = mapResultSetToCart(rs);
                // 设置关联的商品信息
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("product_name"));
                product.setDescription(rs.getString("product_description"));
                product.setPrice(rs.getBigDecimal("product_price"));
                product.setStock(rs.getInt("product_stock"));
                product.setStatus(rs.getInt("product_status"));
                cart.setProduct(product);
                list.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }
    
    /**
     * 查询用户购物车中某商品
     */
    public Cart findByUserIdAndProductId(Integer userId, Integer productId) {
        String sql = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * 根据ID查询购物车项
     */
    public Cart findById(Integer id) {
        String sql = "SELECT * FROM cart WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCart(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * 添加商品到购物车
     */
    public boolean insert(Cart cart) {
        String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cart.getUserId());
            ps.setInt(2, cart.getProductId());
            ps.setInt(3, cart.getQuantity() != null ? cart.getQuantity() : 1);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * 更新购物车数量
     */
    public boolean updateQuantity(Integer id, Integer quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * 删除购物车项
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM cart WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * 清空用户购物车
     */
    public boolean clearByUserId(Integer userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * 获取用户购物车商品数量
     */
    public int getCartCount(Integer userId) {
        String sql = "SELECT SUM(quantity) as total FROM cart WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }
    
    /**
     * 将ResultSet映射为Cart对象
     */
    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getInt("id"));
        cart.setUserId(rs.getInt("user_id"));
        cart.setProductId(rs.getInt("product_id"));
        cart.setQuantity(rs.getInt("quantity"));
        cart.setCreateTime(rs.getTimestamp("create_time"));
        return cart;
    }
}

