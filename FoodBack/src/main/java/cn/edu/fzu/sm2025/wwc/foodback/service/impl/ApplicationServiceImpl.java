package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AppliedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ApplyShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RejectedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Application;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.ApplicationMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.ApplicationService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ApplicationServiceImpl implements ApplicationService {
    @Autowired
    private ApplicationMapper applicationMapper;

    @Override
    public String applyShop(ApplyShopRequest applyShopRequest, String imagePath){
        Application existerApplication = applicationMapper.findApplication
                (applyShopRequest.getShopName(),applyShopRequest.getShopLocation());
        if(existerApplication != null){
            return "申请提交失败，商铺已存在";
        }

//        Application application = getApplication(applyShopRequest);

        Application application = new Application();

        // 设置基本信息
        application.setUserName(applyShopRequest.getUserName());
        application.setShopName(applyShopRequest.getShopName());
        application.setShopLocation(applyShopRequest.getShopLocation());
        application.setShopDescription(applyShopRequest.getShopDescription());
        application.setShopCategory(applyShopRequest.getShopCategory());
        application.setOpenTime(applyShopRequest.getOpenTime());
        application.setCloseTime(applyShopRequest.getCloseTime());

        // 设置图片路径（如果有）
        if (imagePath != null) {
            application.setImagePath("/uploads/shopImage/" + imagePath); // 添加基础路径
            System.out.println(imagePath);
        }

        int rows = applicationMapper.applyShop(application);
        if (rows > 0) {
            return "申请提交成功";
        } else {
            return "申请提交失败，请稍后再试";
        }
    }

    private static Application getApplication(ApplyShopRequest applyShopRequest) {
        Application application = new Application();
        application.setUserName(applyShopRequest.getUserName());
        application.setShopName(applyShopRequest.getShopName());
        application.setShopLocation(applyShopRequest.getShopLocation());
        application.setShopDescription(applyShopRequest.getShopDescription());
        application.setShopCategory(applyShopRequest.getShopCategory());
        application.setCloseTime(applyShopRequest.getCloseTime());
        application.setOpenTime(applyShopRequest.getOpenTime());
        return application;
    }

    @Override
    public PageInfo<Application> getAllApplication(Integer pageNum, Integer pageSize){
        PageHelper.startPage(pageNum, pageSize);
        List<Application> applications = applicationMapper.getAllApplication();
        PageInfo<Application> applicationPageInfo = new PageInfo<>(applications);
        return applicationPageInfo;
    }

    @Override
    public String changeStatus(AppliedResultRequest appliedResultRequest) {
        int rows = applicationMapper.changeStatus(appliedResultRequest);
        if (rows > 0) {
            return "审批成功";
        }else {
            return "审批失败";
        }
    }

    @Override
    public String changeRejectReason(RejectedResultRequest rejectedResultRequest){
        int rows =applicationMapper.changeRejectReason(rejectedResultRequest);
        if (rows > 0) {
            return "拒绝理由添加成功";
        }else {
            return "拒绝理由添加失败";
        }
    }
}
