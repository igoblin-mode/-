package cn.edu.fzu.sm2025.wwc.foodback.entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.math.BigDecimal;
import lombok.Data;

import java.sql.Timestamp;


@Data
public class Review {
    private Integer reviewId;
    private Integer userId;
    private Integer shopId;
    private String content;
    private BigDecimal rating;
    private Timestamp createdAt;

    // 关联字段
//    @JsonInclude(JsonInclude.Include.NON_NULL)
//    private User user;
//
//    @JsonInclude(JsonInclude.Include.NON_NULL)
//    private Shop shop;
}