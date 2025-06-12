package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.dto.RecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.SearchRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import cn.edu.fzu.sm2025.wwc.foodback.entity.User;
import cn.edu.fzu.sm2025.wwc.foodback.service.SearchService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/search")
public class SearchController {

    private final SearchService searchService;

    public SearchController(SearchService searchService) {
        this.searchService = searchService;
    }

    // 全局搜索
    @GetMapping("/all")
    public ResponseEntity<SearchRequest> searchAll(@RequestParam String keyword) {
        SearchRequest result = searchService.searchAll(keyword);
        return ResponseEntity.ok(result);
    }

    // 店铺搜索
    @GetMapping("/shop")
    public ResponseEntity<List<Shop>> searchShops(@RequestParam String keyword) {
        List<Shop> shops = searchService.searchShops(keyword);
        return ResponseEntity.ok(shops);
    }

    // 推荐搜索
    @GetMapping("/recommendation")
    public ResponseEntity<List<RecommendationRequest>> searchRecommendations(@RequestParam String keyword) {
        List<RecommendationRequest> recommendations = searchService.searchRecommendations(keyword);
        return ResponseEntity.ok(recommendations);
    }

    // 用户搜索
    @GetMapping("/user")
    public ResponseEntity<List<User>> searchUsers(@RequestParam String keyword) {
        List<User> users = searchService.searchUsers(keyword);
        return ResponseEntity.ok(users);
    }
}