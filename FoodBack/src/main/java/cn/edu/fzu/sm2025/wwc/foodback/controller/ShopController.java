package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AddShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.service.ShopService;
import cn.edu.fzu.sm2025.wwc.foodback.dto.PageResult;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class ShopController {
    @Autowired
    private ShopService shopService;

    @PostMapping("/addShop")
    public ResponseEntity<?> addShop(@RequestBody AddShopRequest addShopRequest) {
        return shopService.addShop(addShopRequest);
    }

    @GetMapping("/getShop")
    public PageResult<ShopRequest> getShop(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize
    ) {
        PageInfo<ShopRequest> pageInfo = shopService.getAllShop(pageNum, pageSize);
        return new PageResult<>(pageInfo.getTotal(), pageInfo.getList());
    }

    @GetMapping("/getMyShop")
    public List<ShopRequest> getMyShop(
            @RequestParam(defaultValue = "") String ownerName
    ) {
        return shopService.findByOwnerName(ownerName);
    }

    @GetMapping("getShopDetail")
    public ShopRequest getShopDetail(
            @RequestParam(defaultValue = "0") Integer shopId
    ){
        return shopService.getShopDetail(shopId);
    }

    @GetMapping("findShopIdByNameAndLocation")
    public Integer findShopIdByNameAndLocation(
            @RequestParam(defaultValue = "") String shopName,
            @RequestParam(defaultValue = "") String location
    ){
        return shopService.findShopIdByNameAndLocation(shopName,location);
    }

    @GetMapping("getShopByCategory")
    public ResponseEntity<List<ShopRequest>> getShopByCategory(
            @RequestParam(defaultValue = "") String category
    ){
        List<ShopRequest> shopList = shopService.getShopByCategory(category);
        return ResponseEntity.ok(shopList);
    }

    @GetMapping("getShopByRandom")
    public ResponseEntity<List<ShopRequest>> getShopByRandom(){
        List<ShopRequest> shopList = shopService.getShopByRandom();
        return ResponseEntity.ok(shopList);
    }

    @GetMapping("getShopByRating")
    public ResponseEntity<List<ShopRequest>> getShopByRating(){
        List<ShopRequest> shopList = shopService.getShopByRating();
        return ResponseEntity.ok(shopList);
    }
}
