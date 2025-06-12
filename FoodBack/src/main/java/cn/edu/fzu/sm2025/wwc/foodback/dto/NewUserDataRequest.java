package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

@Data
public class NewUserDataRequest {
    private Integer userId;
    private String avatar;
    private String nickName;
}
