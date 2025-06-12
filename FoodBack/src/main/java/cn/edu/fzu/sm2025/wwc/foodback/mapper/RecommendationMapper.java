package cn.edu.fzu.sm2025.wwc.foodback.mapper;

import cn.edu.fzu.sm2025.wwc.foodback.dto.MyRecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RecommendationRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Recommendation;
import org.apache.ibatis.annotations.*;
import org.springframework.http.ResponseEntity;

import java.util.List;

@Mapper
public interface RecommendationMapper {
    // 插入主表记录并返回自增ID
    @Insert("INSERT INTO recommendation (user_id, shop_name, shop_location, description, title) " +
            "VALUES (#{userId}, #{shopName}, #{shopLocation}, #{description}, #{title})")
    @Options(useGeneratedKeys = true, keyProperty = "recommendationId", keyColumn = "recommendation_id")
    int addRecommendation(Recommendation recommendation);

    // 插入图片记录（单条）
    @Insert("INSERT INTO recommendation_image (recommendation_id, image_path) VALUES (#{recommendationId}, #{imagePath})")
    int addImage(@Param("recommendationId") Integer recommendationId,
                 @Param("imagePath") String imagePath);

    //获取到30个推荐信息
    @Select("SELECT * FROM recommendation ORDER BY RAND() LIMIT #{limit}")
    @Results({
            @Result(property = "recommendationId", column = "recommendation_id", id = true),
            // 关联查询图片路径
            //触发条件：当访问Recommendation对象的imagePaths属性时。
            //执行方法：调用RecommendationMapper中的getImagePathsByRecommendationId方法。
            //参数传递：使用当前记录的recommendation_id作为参数。
            @Result(property = "imagePaths", column = "recommendation_id",
                    many = @Many(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.RecommendationMapper.getImagePathsByRecommendationId")),

            // 关联查询用户昵称
            @Result(property = "nickName", column = "user_id",
                    one = @One(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.UserMapper.getNicknameByUserId")),

            // 关联查询用户头像
            @Result(property = "avatar", column = "user_id",
                    one = @One(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.UserMapper.getAvatarByUserId"))
    })
    List<RecommendationRequest> getRandomRecommendation(@Param("limit") int limit);

    @Select("SELECT image_path FROM recommendation_image WHERE recommendation_id = #{recommendationId}")
    List<String> getImagePathsByRecommendationId(@Param("recommendationId") Integer recommendationId);

    @Select("SELECT image_path FROM recommendation_image WHERE recommendation_id = #{recommendationId} LIMIT 1")
    String getOneImagePathByRecommendationId(@Param("recommendationId") Integer recommendationId);

    @Select("SELECT * FROM recommendation")
    List<RecommendationRequest> getAllRecommendation();

    //推荐搜索
    @Select("""
    SELECT
        r.*,
        u.nick_name,
        u.avatar,
        (
            CASE
                WHEN LOWER(r.title) LIKE #{keyword} THEN 0.4
                WHEN LOWER(r.shop_name) LIKE #{keyword} THEN 0.3
                WHEN LOWER(r.description) LIKE #{keyword} THEN 0.2
                WHEN LOWER(r.shop_location) LIKE #{keyword} THEN 0.1
                ELSE 0
            END
        ) AS score
    FROM recommendation r
    LEFT JOIN `user` u ON r.user_id = u.user_id
    WHERE
        LOWER(r.title) LIKE #{keyword}
        OR LOWER(r.shop_name) LIKE #{keyword}
        OR LOWER(r.description) LIKE #{keyword}
        OR LOWER(r.shop_location) LIKE #{keyword}
    ORDER BY score DESC
""")
    @Results({
            @Result(property = "recommendationId", column = "recommendation_id", id = true),
            @Result(property = "imagePaths", column = "recommendation_id",
                    many = @Many(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.RecommendationMapper.getImagePathsByRecommendationId")),
            @Result(property = "nickName", column = "nick_name"),
            @Result(property = "avatar", column = "avatar")
    })
    List<RecommendationRequest> searchRecommendations(@Param("keyword") String keyword);

    //获取到推荐的信息，并获取到推荐的一张图片
    @Select("SELECT * FROM recommendation WHERE user_id = #{userId}")
    @Results({
            @Result(property = "recommendationId", column = "recommendation_id", id = true),
            @Result(property = "imagePath", column = "recommendation_id",
                    one = @One(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.RecommendationMapper.getOneImagePathByRecommendationId"))
    })
    List<MyRecommendationRequest> getMyRecommendation(Integer userId);

    @Select("SELECT * FROM recommendation WHERE recommendation_id = #{id}")
    @Results({
            @Result(property = "recommendationId", column = "recommendation_id", id = true),
            // 关联查询用户昵称
            @Result(property = "nickName", column = "user_id",
                    one = @One(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.UserMapper.getNicknameByUserId")),
            // 关联查询用户头像
            @Result(property = "avatar", column = "user_id",
                    one = @One(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.UserMapper.getAvatarByUserId")),
            @Result(property = "imagePaths", column = "recommendation_id",
                    many = @Many(select = "cn.edu.fzu.sm2025.wwc.foodback.mapper.RecommendationMapper.getImagePathsByRecommendationId"))
    })
    RecommendationRequest getRecommendationById(Integer id);
}
