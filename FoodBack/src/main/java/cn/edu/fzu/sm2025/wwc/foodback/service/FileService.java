package cn.edu.fzu.sm2025.wwc.foodback.service;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface FileService {

//    public ResponseEntity<?> uploadFoodImage(MultipartFile file);

    public String uploadShopImage(MultipartFile file);

    public String saveBase64Image(String base64Image, String imageType) throws IOException;
}
