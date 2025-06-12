package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AppliedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ApplyShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.PageResult;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RejectedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Application;
import cn.edu.fzu.sm2025.wwc.foodback.service.ApplicationService;
import cn.edu.fzu.sm2025.wwc.foodback.service.FileService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
public class ApplicationController {
    @Autowired
    private ApplicationService applicationService;
    @Autowired
    private FileService fileService;

    //申请店铺，添加图片？
    @PostMapping("/applyShop")
    public String applyShop(@RequestBody ApplyShopRequest applyShopRequest) throws IOException {

        String imagePath = null;

        // 如果有图片则处理
        if (applyShopRequest.getShopImage() != null && !applyShopRequest.getShopImage().isEmpty()) {
            // 保存图片并获取相对路径
            imagePath = fileService.saveBase64Image(
                    applyShopRequest.getShopImage(),
                    "shopImage" // 存储到 shopImage 目录
            );
        }

//        // 检查图片是否接收成功
//        if (applyShopRequest.getShopImage() == null || applyShopRequest.getShopImage().isEmpty()) {
//            System.out.println("未接收到图片数据");
//        } else {
//            // 打印前50个字符验
//            String imageData = applyShopRequest.getShopImage();
//            System.out.println("接收到图片数据，长度: " + imageData.length() + " 字符");
//            System.out.println("图片预览: " + imageData);
//        }

        return applicationService.applyShop(applyShopRequest,imagePath);
    }

    @GetMapping("/getApplication")
    public PageResult<Application> getApplication(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize
    ){
        PageInfo<Application> pageInfo = applicationService.getAllApplication(pageNum, pageSize);
        return new PageResult<>(pageInfo.getTotal(), pageInfo.getList());
    }

    @PostMapping("/appliedResult")
    public String appliedResult(@RequestBody AppliedResultRequest appliedResultRequest) {
        return applicationService.changeStatus(appliedResultRequest);
    }

    //将拒绝理由写入
    @PostMapping("/rejectApplication")
    public String rejectApplication(@RequestBody RejectedResultRequest rejectedResultRequest) {
        return applicationService.changeRejectReason(rejectedResultRequest);
    }

}
