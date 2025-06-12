package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.entity.FoodImage;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.FoodImageMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.UUID;


//暂未使用
@RestController
@RequestMapping("/api/files")
public class FileController {
    @Autowired
    private FileService fileService;

//    @PostMapping("/upload/foodImage")
//    public ResponseEntity<?> uploadFoodImage(@RequestParam("file") MultipartFile file) {
//        return fileService.uploadFoodImage(file);
//    }

}


//    @PostMapping("/upload/shopImage")
//    public ResponseEntity<?> uploadShopImage(@RequestParam("file") MultipartFile file) {
//
//    }