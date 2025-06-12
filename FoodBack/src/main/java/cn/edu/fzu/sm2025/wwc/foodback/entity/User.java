package cn.edu.fzu.sm2025.wwc.foodback.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.sql.Timestamp;

/**
 * 用户实体类
 */
@Data
// 除用户名、密码、昵称外均有默认值
public class User {
    private Integer userId;
    private String userName;

    @JsonIgnore
    private String password;

    private String nickName;
    private String avatar;

    //身份，customer，business
    private String role;
    private Timestamp createdAt;

    //用户进行商家申请的状态：unappliedd（未申请），applied，approved
    private String businessStatus;
}