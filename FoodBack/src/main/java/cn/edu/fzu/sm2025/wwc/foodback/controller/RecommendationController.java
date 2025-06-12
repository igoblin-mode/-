package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyRecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.PageResult;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Recommendation;
import cn.edu.fzu.sm2025.wwc.foodback.service.FileService;
import cn.edu.fzu.sm2025.wwc.foodback.service.RecommendationService;
import com.github.pagehelper.PageInfo;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
public class RecommendationController {
    @Autowired
    private RecommendationService recommendationService;
    @Autowired
    private FileService fileService;

    @PostMapping("/addRecommendation")
    public ResponseEntity<?> addRecommendation(@RequestBody Recommendation recommendation) throws IOException {
        List<String> imagePaths = new ArrayList<>();

        // 处理多张图片
        if (recommendation.getImages() != null && !recommendation.getImages().isEmpty()) {
            for (String base64Image : recommendation.getImages()) {
                // 保存每张图片并收集路径
                String imagePath = fileService.saveBase64Image(
                        base64Image,
                        "recommendationImage"
                );
                imagePaths.add(imagePath);
            }
        }

        recommendation.setImages(imagePaths);
        return recommendationService.addRecommendation(recommendation);
    }

    @GetMapping("/getRandomRecommendation")
    public ResponseEntity<List<RecommendationRequest>> getRandomRecommendations(
            @RequestParam(defaultValue = "30") int limit) {
        // 限制最大返回数量
        List<RecommendationRequest> recommendations = recommendationService.getRandomRecommendation(Math.min(limit, 30));
        return ResponseEntity.ok(recommendations);
    }

    @GetMapping("/getMyRecommendation")
    public ResponseEntity<List<MyRecommendationRequest>> getMyRecommendations(
            @RequestParam(defaultValue = "0" ) Integer userId) {
        List<MyRecommendationRequest> myRecommendationRequests = recommendationService.getMyRecommendation(userId);
        return ResponseEntity.ok(myRecommendationRequests);
    }

    @GetMapping("/getRecommendationById")
    public ResponseEntity<RecommendationRequest> getRecommendationById(
            @RequestParam(defaultValue = "0") Integer recommendationId
    ){
        return ResponseEntity.ok(recommendationService.getRecommendationById(recommendationId));
    }
}
