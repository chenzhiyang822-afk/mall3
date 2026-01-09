package com.mall.dao;

import com.mall.entity.Product;
import com.mall.util.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 商品数据访问层
 */
public class ProductDao {
    
    /**
     * 查询所有商品(管理员用)
     */
    public List<Product> findAll() {
        String sql = "SELECT * FROM product ORDER BY id DESC";
        return queryList(sql);
    }
    
    /**
     * 查询上架商品(用户浏览用)
     */
    public List<Product> findOnSale() {
        String sql = "SELECT * FROM product WHERE status = 1 ORDER BY id DESC";
        return queryList(sql);
    }
    
    /**
     * 根据ID查询商品
     */
    public Product findById(Integer id) {
        String sql = "SELECT * FROM product WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * 添加商品
     */
    public boolean insert(Product product) {
        String sql = "INSERT INTO product (name, description, price, stock, status) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStock() != null ? product.getStock() : 0);
            ps.setInt(5, product.getStatus() != null ? product.getStatus() : 1);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * 更新商品
     */
    public boolean update(Product product) {
        String sql = "UPDATE product SET name = ?, description = ?, price = ?, stock = ?, status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setInt(5, product.getStatus());
            ps.setInt(6, product.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * 删除商品
     */
    public boolean delete(Integer id) {
        String sql = "DELETE FROM product WHERE id = ?";
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
     * 更新商品状态(上架/下架)
     */
    public boolean updateStatus(Integer id, Integer status) {
        String sql = "UPDATE product SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, status);
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
     * 搜索商品(按名称模糊搜索)
     */
    public List<Product> search(String keyword) {
        String sql = "SELECT * FROM product WHERE status = 1 AND name LIKE ? ORDER BY id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Product> list = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }
    
    /**
     * 通用查询列表方法
     */
    private List<Product> queryList(String sql) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Product> list = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }
    
    /**
     * 将ResultSet映射为Product对象
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setStatus(rs.getInt("status"));
        product.setCreateTime(rs.getTimestamp("create_time"));
        product.setUpdateTime(rs.getTimestamp("update_time"));
        return product;
    }
}

