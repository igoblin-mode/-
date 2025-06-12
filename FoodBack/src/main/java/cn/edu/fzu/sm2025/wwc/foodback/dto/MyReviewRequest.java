package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class MyReviewRequest {
    private Integer shopId;
    private String shopName;
    private String location;
    private String content;
    private BigDecimal rating;
}
