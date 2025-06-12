package cn.edu.fzu.sm2025.wwc.foodback.entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;


@Data
public class Recommendation {

    private Integer recommendationId;
    private Integer userId;
    private String shopName;
    private String shopLocation;
    private String description;
    private String title;
    // 不需要imagePath字段，改为图片集合
    private List<String> images = new ArrayList<>();
    private Timestamp createdAt;

    // 关联字段
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private User user;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private Shop shop;
}