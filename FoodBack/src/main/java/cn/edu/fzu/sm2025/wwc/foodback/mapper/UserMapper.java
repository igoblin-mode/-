package cn.edu.fzu.sm2025.wwc.foodback.mapper;

import cn.edu.fzu.sm2025.wwc.foodback.dto.LoginRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.NewUserDataRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.User;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface UserMapper {
    @Select("SELECT password FROM user WHERE user_name=#{userName}")
    User login(LoginRequest loginRequest);

    @Insert("INSERT INTO user (nick_name, user_name, password) " +
            "VALUES (#{nickName}, #{userName}, #{password})")
    int register(User user);

    @Select("SELECT * FROM user WHERE user_name = #{userName}")
    User findByUsername(String username);

    @Update("UPDATE user SET role = 'business' WHERE user_name = #{userName}")
    int approveApplication(@Param("userName") String userName);

    // 根据用户ID获取昵称
    @Select("SELECT nick_name FROM user WHERE user_id = #{userId}")
    String getNicknameByUserId(@Param("userId") Integer userId);

    // 根据用户ID获取头像
    @Select("SELECT avatar FROM user WHERE user_id = #{userId}")
    String getAvatarByUserId(@Param("userId") Integer userId);

    //用户搜索
    @Select("""
    SELECT
        u.*,
        (
            CASE
                WHEN LOWER(u.nick_name) = LOWER(#{keyword}) THEN 1.0
                WHEN LOWER(u.nick_name) LIKE CONCAT(LOWER(#{keyword}), '%') THEN 0.9
                WHEN LOWER(u.nick_name) LIKE CONCAT('%', LOWER(#{keyword}), '%') THEN 0.6
                ELSE 0
            END
        ) AS score
    FROM user u
    WHERE LOWER(u.nick_name) LIKE CONCAT('%', LOWER(#{keyword}), '%')
    ORDER BY score DESC
""")
    List<User> searchUsers(@Param("keyword") String keyword);

    //更新
    @Update("UPDATE user SET nick_name = #{nickName}, avatar = #{avatar} WHERE user_id = #{userId}")
    int updateUserInformation(NewUserDataRequest newUserDataRequest);
}
