package cn.edu.fzu.sm2025.wwc.foodback.mapper;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AddShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ShopRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Shop;
import org.apache.ibatis.annotations.*;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface ShopMapper {

    @Select("SELECT * FROM shop WHERE shop_name = #{shopName} AND location = #{location}")
    Shop findByShopNameAndLocation(String shopName, String location);

    @Insert("INSERT INTO shop (" +
            "owner_name, shop_name, location, description, " +
            "image_path, category, open_time, close_time" +
            ") VALUES (" +
            "#{ownerName}, #{shopName}, #{location}, #{description}, " +
            "#{imagePath}, #{category}, #{openTime}, #{closeTime}" +
            ")")
    int addShop(AddShopRequest request);

    @Select("SELECT * FROM shop")
    List<ShopRequest> getAllShop();

    @Select("SELECT * FROM shop WHERE owner_name = #{ownerName}")
    List<ShopRequest> findByOwnerName(String ownerName);

    @Select("SELECT * FROM shop WHERE shop_id = #{shopId}")
    ShopRequest getShopDetail(Integer shopId);

    //店铺搜索
    @Select("""
        SELECT
            s.*,
            (
                CASE
                    WHEN LOWER(s.shop_name) LIKE #{keyword} THEN 0.6
                    WHEN LOWER(s.category) LIKE #{keyword} THEN 0.2
                    WHEN LOWER(s.location) LIKE #{keyword} THEN 0.1
                    WHEN LOWER(s.description) LIKE #{keyword} THEN 0.1
                    ELSE 0
                END
            ) AS score
        FROM shop s
        WHERE
            LOWER(s.shop_name) LIKE #{keyword}
            OR LOWER(s.category) LIKE #{keyword}
            OR LOWER(s.location) LIKE #{keyword}
            OR LOWER(s.description) LIKE #{keyword}
        ORDER BY score DESC
    """)
    List<Shop> searchShops(@Param("keyword") String keyword);

    //更新商铺的评分

    @Update("""
    UPDATE shop SET 
        total_rating = total_rating + #{newRating},
        rating_count = rating_count + 1,
        avg_rating = (total_rating + #{newRating}) / (rating_count + 1)
    WHERE shop_id = #{shopId}
    """)
    void updateShopRating(@Param("shopId") Integer shopId, @Param("newRating") BigDecimal newRating);

    //通过shop_name跟location查找表中是否存在该店铺，没找到返回null
    @Select("SELECT shop_id FROM shop WHERE shop_name = #{shopName} AND location = #{shopLocation} LIMIT 1")
    Integer findShopIdByNameAndLocation(
            @Param("shopName") String shopName,
            @Param("shopLocation") String shopLocation
    );

    //根据店铺类别查询(随机且最多三十份)
    @Select("SELECT * FROM shop WHERE category = #{category} ORDER BY RAND() LIMIT 30")
    List<ShopRequest> getShopByCategory(@Param("category") String category);

    @Select("SELECT * FROM shop ORDER BY avg_rating DESC LIMIT 30")
    List<ShopRequest> getShopByAvgRating();

    @Select("""
    SELECT s.* FROM shop s
    JOIN (
        SELECT shop_id
        FROM shop
        ORDER BY RAND()
        LIMIT 30
    ) AS temp ON s.shop_id = temp.shop_id
    """)
    List<ShopRequest> getShopByRand();
}


