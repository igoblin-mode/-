package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ShopRequest {
    private Integer shopId;
    private String ownerName;
    private String shopName;
    private String location;
    private String description;
    private String imagePath;
    private String category;
    private String openTime;
    private String closeTime;
    private BigDecimal avgRating;
}
