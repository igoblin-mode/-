package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class RecommendationRequest {
    Integer recommendationId;
    String nickName;
    String avatar;
    String shopName;
    String title;
    String shopLocation;
    String description;
    // 图片路径集合
    List<String> imagePaths = new ArrayList<>();

}
