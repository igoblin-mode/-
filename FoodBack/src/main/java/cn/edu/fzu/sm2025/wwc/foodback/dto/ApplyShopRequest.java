package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

@Data
public class ApplyShopRequest {
    private String userName;
    private String shopName;
    private String shopLocation;
    private String shopDescription;
    private String shopCategory;
    private String openTime;
    private String closeTime;
    private String shopImage;
}
