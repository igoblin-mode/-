package cn.edu.fzu.sm2025.wwc.foodback.service;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Review;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface ReviewService {
    ResponseEntity<?> addReview(Review review);

    List<ReviewRequest> getViewDetail(Integer shopId);

    List<MyReviewRequest> getMyReview(Integer userId);
}
