package com.mall.dao;

import com.mall.entity.User;
import com.mall.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 用户数据访问层
 */
public class UserDao {
    
    /**
     * 根据用户名和密码查询用户(登录验证)
     */
    public User findByUsernameAndPassword(String username, String password) {
        String sql = "SELECT * FROM user WHERE username = ? AND password = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * 根据用户名查询用户(检查用户名是否存在)
     */
    public User findByUsername(String username) {
        String sql = "SELECT * FROM user WHERE username = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
    
    /**
     * 添加新用户(注册)
     */
    public boolean insert(User user) {
        String sql = "INSERT INTO user (username, password, email, phone, role) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setInt(5, user.getRole() != null ? user.getRole() : 0);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }
    
    /**
     * 将ResultSet映射为User对象
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getInt("role"));
        user.setCreateTime(rs.getTimestamp("create_time"));
        user.setUpdateTime(rs.getTimestamp("update_time"));
        return user;
    }
}

