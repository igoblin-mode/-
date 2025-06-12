package cn.edu.fzu.sm2025.wwc.foodback.mapper;

import cn.edu.fzu.sm2025.wwc.foodback.dto.AppliedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RejectedResultRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.Application;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface ApplicationMapper {

    @Select("SELECT * FROM application WHERE shop_name = #{shopName} AND shop_location = #{shopLocation}")
    Application findApplication(String shopName, String shopLocation);

    @Insert("INSERT INTO application (user_name, shop_name, shop_location, " +
            "shop_description,shop_category,open_time, close_time,image_path)" +
            "VALUES " + "(#{userName}, #{shopName}, #{shopLocation}," +
            " #{shopDescription}, #{shopCategory}, #{openTime}, #{closeTime}, #{imagePath})")
    int applyShop(Application application);

    @Select("SELECT * FROM application ORDER BY IF(status = 'pending', 0, 1), status")
    List<Application> getAllApplication();

    @Update("UPDATE application SET status = #{status} WHERE application_id = #{applicationId}")
    int changeStatus(AppliedResultRequest appliedResultRequest);

    @Update("UPDATE application SET rejection_reason = #{rejectionReason} WHERE application_id = #{applicationId}")
    int changeRejectReason(RejectedResultRequest rejectedResultRequest);
}
