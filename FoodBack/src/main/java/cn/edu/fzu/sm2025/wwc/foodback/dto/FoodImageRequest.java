package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

@Data
public class FoodImageRequest {
    private Integer shopId;
    private String name;             // 图片展示的美食名称
    private double price;            // 美食价格
    private String description;      // 美食描述
    private String imagePath;

}
