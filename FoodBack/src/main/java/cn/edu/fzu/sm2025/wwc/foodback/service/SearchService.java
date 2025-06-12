package cn.edu.fzu.sm2025.wwc.foodback.service;

import cn.edu.fzu.sm2025.wwc.foodback.dto.RecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Recommendation;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import cn.edu.fzu.sm2025.wwc.foodback.entity.User;
import cn.edu.fzu.sm2025.wwc.foodback.dto.SearchRequest;

import java.util.List;

public interface SearchService {

    /**
     * 统一搜索接口
     * @param keyword 搜索关键词
     * @return 包含店铺、推荐和用户搜索结果的聚合对象
     */
    SearchRequest searchAll(String keyword);

    /**
     * 店铺搜索
     * @param keyword 搜索关键词
     * @return 匹配的店铺列表
     */
    List<Shop> searchShops(String keyword);

    /**
     * 推荐搜索
     * @param keyword 搜索关键词
     * @return 匹配的推荐内容列表
     */
    List<RecommendationRequest> searchRecommendations(String keyword);

    /**
     * 用户搜索
     * @param keyword 搜索关键词
     * @return 匹配的用户列表
     */
    List<User> searchUsers(String keyword);
}