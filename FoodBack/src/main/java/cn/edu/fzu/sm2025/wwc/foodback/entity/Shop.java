package cn.edu.fzu.sm2025.wwc.foodback.entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

import java.math.BigDecimal;
import java.sql.Time;
import java.util.Date;
import java.sql.Timestamp;

import java.util.List;

@Data
public class Shop {
    private Integer shopId;
    private String ownerName;
    private String shopName;
    private String location;
    private String description;
    private String imagePath;
    private String category;
    private Time openTime;
    private Time closeTime;
    private BigDecimal avgRating;
    private Integer ratingCount;
    private BigDecimal totalRating;
    private Timestamp createdAt;

    // 关联字段
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private User owner;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private List<MenuItem> menuItems;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private List<Review> reviews;

}