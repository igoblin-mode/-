package cn.edu.fzu.sm2025.wwc.foodback.service.impl;

import cn.edu.fzu.sm2025.wwc.foodback.dto.NewUserDataRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RegisterRequest;
import cn.edu.fzu.sm2025.wwc.foodback.utils.Md5Util;
import cn.edu.fzu.sm2025.wwc.foodback.dto.LoginRequest;
import cn.edu.fzu.sm2025.wwc.foodback.entity.User;
import cn.edu.fzu.sm2025.wwc.foodback.mapper.UserMapper;
import cn.edu.fzu.sm2025.wwc.foodback.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public String login(LoginRequest loginRequest) {
        User user = userMapper.login(loginRequest);
        if (user == null) {
            return "用户名错误";
        }else if (Md5Util.checkPassword(loginRequest.getPassword(), user.getPassword())) {
            return "登录成功";
        }else {
            return "密码错误";
        }
    }

    public String register(RegisterRequest registerRequest) {
        // 检查用户名是否已存在
        User existingUser = userMapper.findByUsername(registerRequest.getUserName());
        if (existingUser != null) {
            return "注册失败，用户名已存在";
        }

        // 密码加密
        String encryptedPassword = Md5Util.getMD5String(registerRequest.getPassword());

        // 创建用户对象,仅存入用户名、密码、昵称、其与有默认值
        User user = new User();
        user.setNickName(registerRequest.getNickName());
        user.setUserName(registerRequest.getUserName());
        user.setPassword(encryptedPassword);

        // 持久化到数据库
        int rows = userMapper.register(user);
        if (rows > 0) {
            return "注册成功";
        } else {
            return "注册失败，请稍后再试";
        }
    }

    public String approveApplication(String userName) {
        int rows = userMapper.approveApplication(userName);
        if (rows > 0) {
            return "更改为商家成功";
        }else {
            return "更改为商家失败";
        }
    }

    public ResponseEntity<?> getUserInformation(String userName){
        User user = userMapper.findByUsername(userName);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    public  ResponseEntity<?> updateUserInformation(NewUserDataRequest newUserDataRequest){
        int row = userMapper.updateUserInformation(newUserDataRequest);
        if (row > 0) {
            return ResponseEntity.ok().body("更新用户信息成功");
        }else{
            return ResponseEntity.status(500).body("更新用户信息失败");
        }
    }
}
