package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.dto.FoodImageRequest;
import cn.edu.fzu.sm2025.wwc.foodback.service.FileService;
import cn.edu.fzu.sm2025.wwc.foodback.service.FoodImageService;
import cn.edu.fzu.sm2025.wwc.foodback.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
public class FoodImageController {
    @Autowired
    private FoodImageService foodImageService;
    @Autowired
    private FileService fileService;

    @GetMapping("getFoodImageDetail")
    List<FoodImageRequest> getFoodImageDetail(
            @RequestParam(defaultValue = "0") Integer shopId
    ){
        return foodImageService.getFoodImageDetail(shopId);
    }

    @PostMapping("addFoodImage")
    ResponseEntity<?> addFoodImage(@RequestBody FoodImageRequest foodImageRequest) throws IOException {

        String imagePath = null;

        // 如果有图片则处理
        if (foodImageRequest.getImagePath() != null && !foodImageRequest.getImagePath().isEmpty()) {
            // 保存图片并获取相对路径
            imagePath = fileService.saveBase64Image(
                    foodImageRequest.getImagePath(),
                    "foodImage" // 存储到 shopImage 目录
            );
        }

        return foodImageService.addFoodImage(foodImageRequest,imagePath);
    }
}
