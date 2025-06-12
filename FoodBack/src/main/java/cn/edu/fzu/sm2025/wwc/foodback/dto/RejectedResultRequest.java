package cn.edu.fzu.sm2025.wwc.foodback.dto;

import lombok.Data;

@Data
public class RejectedResultRequest {
    Integer applicationId;
    String rejectionReason;
}
