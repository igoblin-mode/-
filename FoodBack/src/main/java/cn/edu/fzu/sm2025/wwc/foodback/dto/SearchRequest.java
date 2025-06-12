package cn.edu.fzu.sm2025.wwc.foodback.dto;

import cn.edu.fzu.sm2025.wwc.foodback.entity.Recommendation;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import cn.edu.fzu.sm2025.wwc.foodback.entity.User;
import lombok.Data;

import java.util.List;

@Data
public class SearchRequest {
    List<Shop> shopResults;
    List<RecommendationRequest> recommendationResults;
    List<User> userResults;
}
