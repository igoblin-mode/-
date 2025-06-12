package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

@Data
public class MyRecommendationRequest {
    private Integer recommendationId;
    private String shopName;
    private String title;
    private String shopLocation;
    private String description;
    private String imagePath;
}
