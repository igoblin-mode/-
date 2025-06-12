package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.controller.FileController;
import cn.edu.fzu.sm2025.wwc.foodback.entity.FoodImage;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.FoodImageMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.Map;
import java.util.UUID;

@Service
public class FileServiceImpl implements FileService {

    @Autowired
    private Path uploadPath;
    @Autowired
    private FoodImageMapper foodImageMapper;

//    @Override
//    public ResponseEntity<?> uploadFoodImage(@RequestParam("file") MultipartFile file){
//        try {
//            // 1. 生成唯一文件名
//            String originalName = file.getOriginalFilename();
//            String suffix = originalName.substring(originalName.lastIndexOf("."));
//            String fileName = UUID.randomUUID() + suffix; // 如：3b6f8c9d.jpg
//
//            // 2. 构建存储路径（按日期分目录）
//            String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
//            //存储到菜品图片里
//            Path targetDir = uploadPath.resolve("foodImage").resolve(dateDir);
//            Files.createDirectories(targetDir);
//
//            // 3. 写入文件系统
//            Path targetPath = targetDir.resolve(fileName);
//            Files.copy(file.getInputStream(), targetPath);
//
//            // 4. 记录到数据库
//            FoodImage image = new FoodImage();
//            image.setFileName(fileName);
//            image.setImagePath(dateDir + "/" + fileName);
//            image.setUploadTime(LocalDateTime.now());
//            foodImageMapper.insert(image);
//
//            return ResponseEntity.ok(Map.of(
//                    "url", "/uploads/foodImage/" + image.getImagePath(),
//                    "message", "上传成功"
//            ));
//        } catch (IOException e) {
//            return ResponseEntity.status(500).body(Map.of("error", "文件写入失败"));
//        }
//    }

    //返回到相对地址给...?
    @Override
    public String uploadShopImage(@RequestParam("file") MultipartFile file){
        try {
            // 1. 生成唯一文件名
            String originalName = file.getOriginalFilename();
            String suffix = originalName.substring(originalName.lastIndexOf("."));
            String fileName = UUID.randomUUID() + suffix; // 如：3b6f8c9d.jpg

            // 2. 构建存储路径（按日期分目录）
            String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            //存储到菜品图片里
            Path targetDir = uploadPath.resolve("shopImage").resolve(dateDir);
            Files.createDirectories(targetDir);

            // 3. 写入文件系统
            Path targetPath = targetDir.resolve(fileName);
            Files.copy(file.getInputStream(), targetPath);

            return dateDir + "/" + fileName;
        } catch (IOException e) {
            return "";
        }
    }

    //将图片写入到文件系统中，传入图片的base64格式，跟存储的位置的名字如foodImage
    //在插入数据库时的自己添加上基础路径，如/uploads/foodImage/
    @Override
    public String saveBase64Image(String base64Image, String imageType) throws IOException {
        try {

            // 1. 检查并清理 Base64 前缀
            String base64Data = base64Image;
            if (base64Data.contains(",")) {
                base64Data = base64Data.split(",")[1];
            }

            // 2. 解码 Base64
            byte[] imageBytes;
            try {
                imageBytes = Base64.getDecoder().decode(base64Data);
            } catch (IllegalArgumentException e) {
                throw new IOException("无效的 Base64 格式: " + e.getMessage());
            }

            // 3. 生成唯一文件名 (使用.jpg扩展名，因为Base64通常不包含原始扩展名)
            String fileName = UUID.randomUUID() + ".jpg";

            // 4. 构建存储路径（按日期分目录）- 与原始方法完全一致
            String dateDir = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            Path targetDir = uploadPath.resolve(imageType).resolve(dateDir);

            // 确保目录存在 - 与原始方法一致
            if (!Files.exists(targetDir)) {
                Files.createDirectories(targetDir);
            }

            // 5. 创建文件路径并写入文件系统
            Path targetPath = targetDir.resolve(fileName);

            // 使用 Files.write 方法写入文件
            Files.write(targetPath, imageBytes);

            // 6. 返回相对路径（格式与原始方法一致）
            return dateDir + "/" + fileName;

        } catch (Exception e) {
            throw new IOException("保存图片失败: " + e.getMessage(), e);
        }
    }
}
