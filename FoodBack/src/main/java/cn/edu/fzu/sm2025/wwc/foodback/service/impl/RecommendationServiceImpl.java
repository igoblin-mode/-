package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyRecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Recommendation;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.RecommendationMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.RecommendationService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RecommendationServiceImpl implements RecommendationService {
    @Autowired
    private RecommendationMapper recommendationMapper;

    public ResponseEntity<?> addRecommendation(Recommendation recommendation){

        try {

            //System.out.println("one"+recommendation.getRecommendationId());

            // 1. 插入主表记录
            recommendationMapper.addRecommendation(recommendation);

            //System.out.println("two"+recommendation.getRecommendationId());

            // 2. 获取自增ID
            Integer recommendationId = recommendation.getRecommendationId();

            // 3. 插入图片记录
            for (String imagePath : recommendation.getImages()) {
                recommendationMapper.addImage(recommendationId, "/uploads/recommendationImage/" +imagePath);
            }

            return ResponseEntity.ok("店铺推荐添加成功");
        } catch (Exception e) {
            e.printStackTrace(); // 打印完整错误
            return ResponseEntity.status(500).body("添加失败: " + e.getMessage());
        }
    }

    public PageInfo<RecommendationRequest> getAllRecommendation(int pageNum, int pageSize){
        PageHelper.startPage(pageNum, pageSize);
        List<RecommendationRequest> recommendations = recommendationMapper.getAllRecommendation();
        return new PageInfo<>(recommendations);
    }

    public List<RecommendationRequest> getRandomRecommendation(int limit) {
        // 使用数据库函数随机排序
        return recommendationMapper.getRandomRecommendation(limit);
    }

    public List<MyRecommendationRequest> getMyRecommendation(Integer userId){
        return recommendationMapper.getMyRecommendation(userId);
    }

    public RecommendationRequest getRecommendationById(Integer id){
        return recommendationMapper.getRecommendationById(id);
    }
}
