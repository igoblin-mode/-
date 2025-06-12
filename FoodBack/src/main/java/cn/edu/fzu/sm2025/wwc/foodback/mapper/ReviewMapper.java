package cn.edu.fzu.sm2025.wwc.foodback.mapper;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.ReviewRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Review;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ReviewMapper {
    @Insert("INSERT INTO review (user_id,shop_id,content,rating)"+
    "VALUES"+"(#{userId},#{shopId},#{content},#{rating})")
    int addReview(Review review);

    @Select("SELECT r.*, u.nick_name, u.avatar FROM review r " +
            "JOIN user u ON r.user_id = u.user_id " +
            "WHERE r.shop_id = #{shopId}")
    List<ReviewRequest> getViewDetail(Integer shopId);

    @Select("SELECT r.*, s.shop_name, s.location FROM review r " +
            "JOIN shop s ON r.shop_id = s.shop_id " +
            "WHERE r.user_id = #{userId}")
    List<MyReviewRequest> getMyReview(Integer userId);
}
