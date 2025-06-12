package cn.edu.fzu.sm2025.wwc.foodback.service;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyRecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Recommendation;
import com.github.pagehelper.PageInfo;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface RecommendationService {
    ResponseEntity<?> addRecommendation(Recommendation recommendation);

    PageInfo<RecommendationRequest> getAllRecommendation(int pageNum, int pageSize);

    List<RecommendationRequest> getRandomRecommendation(int limit);

    List<MyRecommendationRequest> getMyRecommendation(Integer userId);

    RecommendationRequest getRecommendationById(Integer id);
}
