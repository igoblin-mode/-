package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Review;
import cn.edu.fzu.sm2025.wwc.foodback.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class ReviewController {
    @Autowired
    private ReviewService reviewService;

    @PostMapping("addReview")
    public ResponseEntity<?> addReview(@RequestBody Review review) {
        return reviewService.addReview(review);
    }

    @GetMapping("getReviewDetail")
    public List<ReviewRequest> getReviewDetail(
            @RequestParam (defaultValue = "0") Integer shopId
    ) {
        return reviewService.getViewDetail(shopId);
    }

    @GetMapping("getMyReview")
    public List<MyReviewRequest> getMyReview(
            @RequestParam (defaultValue = "0") Integer userId
    ){
        return reviewService.getMyReview(userId);
    }
}
