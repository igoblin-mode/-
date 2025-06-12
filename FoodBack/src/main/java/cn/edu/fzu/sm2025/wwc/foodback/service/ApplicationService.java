package cn.edu.fzu.sm2025.wwc.foodback.service;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AppliedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ApplyShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RejectedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Application;
import com.github.pagehelper.PageInfo;

public interface ApplicationService {
    String applyShop(ApplyShopRequest applyShopRequest, String imagePath);

    PageInfo<Application> getAllApplication(Integer pageNum, Integer pageSize);

    String changeStatus(AppliedResultRequest appliedResultRequest);

    String changeRejectReason(RejectedResultRequest rejectedResultRequest);
}
