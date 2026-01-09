package com.mall.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 数据库连接工具类
 */
public class DBUtil {
    
    // 数据库连接配置
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/mall?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "123456";
    
    static {
        try {
            // 加载驱动
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
    
    /**
     * 关闭资源
     */
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 关闭资源(无ResultSet)
     */
    public static void close(Connection conn, PreparedStatement ps) {
        close(conn, ps, null);
    }
}

