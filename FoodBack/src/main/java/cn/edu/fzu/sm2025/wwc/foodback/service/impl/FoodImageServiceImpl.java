package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.dto.FoodImageRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.FoodImage;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.FoodImageMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.FoodImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FoodImageServiceImpl implements FoodImageService {
    @Autowired
    private FoodImageMapper foodImageMapper;

    @Override
    public List<FoodImageRequest> getFoodImageDetail(Integer shopId){
        return foodImageMapper.getFoodImageDetail(shopId);
    }

    public ResponseEntity<?> addFoodImage(FoodImageRequest foodImageRequest,String imagePath){

        FoodImage foodImage = new FoodImage();
        foodImage.setImagePath("/uploads/foodImage/" + imagePath);
        foodImage.setShopId(foodImageRequest.getShopId());
        foodImage.setDescription(foodImageRequest.getDescription());
        foodImage.setName(foodImageRequest.getName());
        foodImage.setPrice(foodImageRequest.getPrice());

        int rows = foodImageMapper.addFoodImage(foodImage);
        if(rows > 0){
            return ResponseEntity.ok("添加菜品成功");
        }else{
            return ResponseEntity.status(500).body("添加菜品失败");
        }
    }
}
