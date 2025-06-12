package cn.edu.fzu.sm2025.wwc.foodback.service;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AddShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ShopRequest;
import com.github.pagehelper.PageInfo;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface ShopService {
    ResponseEntity<?> addShop(AddShopRequest request);

    PageInfo<ShopRequest> getAllShop(int pageNum, int pageSize);

    List<ShopRequest> findByOwnerName(String ownerName);

    ShopRequest getShopDetail(int shopId);

    Integer findShopIdByNameAndLocation(String shopName,String location);

    List<ShopRequest> getShopByCategory(String category);

    List<ShopRequest> getShopByRating();

    List<ShopRequest> getShopByRandom();
}
