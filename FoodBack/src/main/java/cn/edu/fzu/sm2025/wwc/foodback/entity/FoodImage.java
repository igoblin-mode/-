package cn.edu.fzu.sm2025.wwc.foodback.entity;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
public class FoodImage  {
    private Integer imageId;
    private Integer shopId;
    private String name;             // 图片展示的美食名称
    private String imagePath;
    private double price;            // 美食价格
    private String description;      // 美食描述


}