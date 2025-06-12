package cn.edu.fzu.sm2025.wwc.foodback.entity;

import lombok.Data;
import java.sql.Time;
import java.sql.Timestamp;

@Data
public class Application {
    private Integer applicationId;
    private String userName;
    private String shopName;
    private String shopLocation;
    private String shopDescription;
    private String shopCategory;
    private String openTime;
    private String closeTime;
    private String status;
    private Timestamp createdAt;
    private Timestamp reviewedAt;
    private String rejectionReason;
    private String imagePath;
}