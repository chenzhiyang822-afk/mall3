-- 商城数据库初始化脚本
-- 创建数据库
CREATE DATABASE IF NOT EXISTS mall DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE mall;

-- 用户表
CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    role INT DEFAULT 0 COMMENT '角色: 0-普通用户, 1-管理员',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 商品表
CREATE TABLE IF NOT EXISTS product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '商品名称',
    description TEXT COMMENT '商品描述',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    stock INT DEFAULT 0 COMMENT '库存',
    status INT DEFAULT 1 COMMENT '状态: 0-下架, 1-上架',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 购物车表
CREATE TABLE IF NOT EXISTS cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    quantity INT DEFAULT 1 COMMENT '数量',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- 订单表
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) NOT NULL UNIQUE COMMENT '订单号',
    user_id INT NOT NULL COMMENT '用户ID',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    status INT DEFAULT 0 COMMENT '状态: 0-待付款, 1-已付款, 2-已发货, 3-已完成, 4-已取消',
    address VARCHAR(200) COMMENT '收货地址',
    phone VARCHAR(20) COMMENT '联系电话',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单详情表
CREATE TABLE IF NOT EXISTS order_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL COMMENT '订单ID',
    product_id INT NOT NULL COMMENT '商品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '商品名称(冗余)',
    price DECIMAL(10,2) NOT NULL COMMENT '购买时价格',
    quantity INT NOT NULL COMMENT '数量',
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表';

-- 插入初始数据

-- 管理员账户 (密码: admin123)
INSERT INTO user (username, password, email, phone, role) VALUES 
('admin', 'admin123', 'admin@mall.com', '13800000000', 1);

-- 普通用户 (密码: user123)
INSERT INTO user (username, password, email, phone, role) VALUES 
('user1', 'user123', 'user1@mall.com', '13800000001', 0),
('user2', 'user123', 'user2@mall.com', '13800000002', 0);

-- 商品数据
INSERT INTO product (name, description, price, stock, status) VALUES 
('iPhone 15', 'Latest Apple smartphone with A17 chip', 7999.00, 100, 1),
('MacBook Pro', '14-inch laptop with M3 chip', 14999.00, 50, 1),
('AirPods Pro', 'Wireless earbuds with noise cancellation', 1899.00, 200, 1),
('T-Shirt', 'Cotton casual t-shirt', 99.00, 500, 1),
('Jeans', 'Classic blue denim jeans', 299.00, 300, 1),
('Java Programming', 'Complete guide to Java development', 89.00, 100, 1),
('Spring Boot Guide', 'Master Spring Boot framework', 69.00, 80, 1),
('Green Tea', 'Organic green tea leaves', 45.00, 200, 1),
('Coffee Beans', 'Premium arabica coffee beans', 128.00, 150, 1);
