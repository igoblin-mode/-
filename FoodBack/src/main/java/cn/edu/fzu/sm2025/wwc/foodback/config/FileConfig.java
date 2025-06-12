//动态获取路径

package cn.edu.fzu.sm2025.wwc.foodback.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class FileConfig {
    @Value("${file.upload.base-dir}")
    private String uploadDir;

    @Bean
    public Path uploadPath() {
        // 动态获取项目根目录
        Path path = Paths.get(System.getProperty("user.dir"), uploadDir);
        try {
            Files.createDirectories(path);
        } catch (IOException e) {
            throw new RuntimeException("上传目录创建失败", e);
        }
        return path;
    }
}