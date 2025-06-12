package cn.edu.fzu.sm2025.wwc.foodback.entity;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.math.BigDecimal;
import lombok.Data;

@Data
public class MenuItem {
    private Integer itemId;
    private Integer shopId;
    private String name;
    private String image;
    private BigDecimal price;
    private String description;

    // 关联字段
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private Shop shop;
}
