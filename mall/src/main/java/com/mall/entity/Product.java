package com.mall.entity;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 商品实体类
 */
public class Product {
    
    private Integer id;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stock;
    private Integer status;  // 0-下架, 1-上架
    private Date createTime;
    private Date updateTime;
    
    public Product() {
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public Integer getStock() {
        return stock;
    }
    
    public void setStock(Integer stock) {
        this.stock = stock;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setStatus(Integer status) {
        this.status = status;
    }
    
    public Date getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
    
    public Date getUpdateTime() {
        return updateTime;
    }
    
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
    
    /**
     * 判断是否上架
     */
    public boolean isOnSale() {
        return status != null && status == 1;
    }
}

