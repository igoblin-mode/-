package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AddShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.ShopMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.ShopService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ShopServiceImpl implements ShopService {
    @Autowired
    private ShopMapper shopMapper;

    @Override
    public ResponseEntity<?> addShop(AddShopRequest request){
        Shop existerShop = shopMapper.findByShopNameAndLocation(
                request.getShopName(), request.getLocation());
        if(existerShop != null){
            ResponseEntity.status(400).body("店铺已存在");
        }
        AddShopRequest addShopRequest = getAddShopRequest(request);

        int rows = shopMapper.addShop(addShopRequest);
        if(rows > 0){
            return ResponseEntity.ok("店铺添加成功");
        }else {
            return ResponseEntity.status(500).body("店铺添加失败");
        }
    }

    private static AddShopRequest getAddShopRequest(AddShopRequest request) {
        AddShopRequest addShopRequest = new AddShopRequest();
        addShopRequest.setOwnerName(request.getOwnerName());
        addShopRequest.setShopName(request.getShopName());
        addShopRequest.setLocation(request.getLocation());
        addShopRequest.setDescription(request.getDescription());
        addShopRequest.setImagePath(request.getImagePath());
        addShopRequest.setCategory(request.getCategory());
        addShopRequest.setOpenTime(request.getOpenTime());
        addShopRequest.setCloseTime(request.getCloseTime());
        return addShopRequest;
    }

    @Override
    public PageInfo<ShopRequest> getAllShop(int pageNum, int pageSize){
        PageHelper.startPage(pageNum, pageSize);
        List<ShopRequest> shops = shopMapper.getAllShop();
        return new PageInfo<>(shops);
    }

    @Override
    public List<ShopRequest> findByOwnerName(String ownerName){
        return shopMapper.findByOwnerName(ownerName);
    }

    @Override
    public  ShopRequest getShopDetail(int shopId){
        return shopMapper.getShopDetail(shopId);
    }

    @Override
    public  Integer findShopIdByNameAndLocation(String shopName,String location){
        return shopMapper.findShopIdByNameAndLocation(shopName,location);
    }

    @Override
    public List<ShopRequest> getShopByCategory(String category){
        return shopMapper.getShopByCategory(category);
    }

    @Override
    public List<ShopRequest> getShopByRandom(){
        return shopMapper.getShopByRand();
    }

    @Override
    public List<ShopRequest> getShopByRating(){
        return shopMapper.getShopByAvgRating();
    }
}
