package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

@Data
public class AddShopRequest {
    private String ownerName;
    private String shopName;
    private String location;
    private String description;
    private String imagePath;
    private String category;
    private String openTime;
    private String closeTime;
}
