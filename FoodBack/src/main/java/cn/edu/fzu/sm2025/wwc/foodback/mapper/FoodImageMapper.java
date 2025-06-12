package cn.edu.fzu.sm2025.wwc.foodback.mapper;

import cn.edu.fzu.sm2025.wwc.foodback.dto.FoodImageRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.FoodImage;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface FoodImageMapper {
    //将图片信息放入数据表中,数据表属性已修改
//    @Insert("INSERT INTO foodimage (file_name, image_path, upload_time) " +
//            "VALUES (#{fileName}, #{imagePath}, #{uploadTime})")
//    @Options(useGeneratedKeys = true, keyProperty = "imageId")
//    void insert(FoodImage image);

    @Select("SELECT * FROM foodimage WHERE shop_id = #{shopId}")
    List<FoodImageRequest> getFoodImageDetail(Integer shopId);


    @Insert("INSERT INTO foodimage (" +
            "shop_id, name, image_path, price, description" +
            ") VALUES (" +
            "#{shopId}, #{name}, #{imagePath}, #{price}, #{description}" +
            ")")
    @Options(useGeneratedKeys = true, keyProperty = "imageId", keyColumn = "image_id")
    int addFoodImage(FoodImage foodImage);
}