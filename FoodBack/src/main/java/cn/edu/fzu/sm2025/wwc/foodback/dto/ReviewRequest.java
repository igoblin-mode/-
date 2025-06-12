package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class ReviewRequest {
    private String nickName;
    private String avatar;
    private Integer shopId;
    private String content;
    private BigDecimal rating;
    private Timestamp createdAt;
}
