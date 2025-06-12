package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.dto.RecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.SearchRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Recommendation;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import cn.edu.fzu.sm2025.wwc.foodback.entity.User;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.RecommendationMapper;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.ShopMapper;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.UserMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.SearchService;
import io.micrometer.common.util.StringUtils;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class SearchServiceImpl implements SearchService {

    private final ShopMapper shopMapper;
    private final RecommendationMapper recommendationMapper;
    private final UserMapper userMapper;

    public SearchServiceImpl(ShopMapper shopMapper,
                             RecommendationMapper recommendationMapper,
                             UserMapper userMapper) {
        this.shopMapper = shopMapper;
        this.recommendationMapper = recommendationMapper;
        this.userMapper = userMapper;
    }

    @Override
    public SearchRequest searchAll(String keyword) {
        SearchRequest result = new SearchRequest();
        result.setShopResults(searchShops(keyword));
        result.setRecommendationResults(searchRecommendations(keyword));
        result.setUserResults(searchUsers(keyword));
        return result;
    }

    @Override
    public List<Shop> searchShops(String keyword) {
        if (StringUtils.isBlank(keyword)) {
            return Collections.emptyList();
        }

        String cleanKeyword = "%" + keyword.trim().toLowerCase() + "%";
        return shopMapper.searchShops(cleanKeyword);
    }

    @Override
    public List<RecommendationRequest> searchRecommendations(String keyword) {
        if (StringUtils.isBlank(keyword)) {
            return Collections.emptyList();
        }

        String cleanKeyword = "%" + keyword.trim().toLowerCase() + "%";
        return recommendationMapper.searchRecommendations(cleanKeyword);
    }

    @Override
    public List<User> searchUsers(String keyword) {
        if (StringUtils.isBlank(keyword)) {
            return Collections.emptyList();
        }

        String cleanKeyword = keyword.trim().toLowerCase();
        return userMapper.searchUsers(cleanKeyword);
    }
}