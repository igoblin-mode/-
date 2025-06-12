package cn.edu.fzu.sm2025.wwc.foodback.service;

import cn.edu.fzu.sm2025.wwc.foodback.dto.FoodImageRequest;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface FoodImageService {
    List<FoodImageRequest> getFoodImageDetail(Integer shopId);

    ResponseEntity<?> addFoodImage(FoodImageRequest foodImageRequest,String imagePath);
}
