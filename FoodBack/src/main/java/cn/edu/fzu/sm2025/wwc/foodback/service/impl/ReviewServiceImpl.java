package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Review;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.ReviewMapper;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.ShopMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReviewServiceImpl implements ReviewService {
    @Autowired
    ReviewMapper reviewMapper;
    @Autowired
    ShopMapper shopMapper;

    public ResponseEntity<?> addReview(Review review){
        int rows = reviewMapper.addReview(review);
        shopMapper.updateShopRating(review.getShopId(),review.getRating());
        if(rows > 0){
            return ResponseEntity.ok("评论添加成功");
        }else {
            return ResponseEntity.status(500).body("评论添加失败");
        }
    }

    public List<ReviewRequest> getViewDetail(Integer shopId){
        return reviewMapper.getViewDetail(shopId);
    }

    public List<MyReviewRequest> getMyReview(Integer userId){
        return reviewMapper.getMyReview(userId);
    }
}
