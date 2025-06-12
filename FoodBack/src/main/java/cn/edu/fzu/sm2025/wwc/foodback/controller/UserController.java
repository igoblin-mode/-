package cn.edu.fzu.sm2025.wwc.foodback.controller;

import cn.edu.fzu.sm2025.wwc.foodback.dto.LoginRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.NewUserDataRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RegisterRequest;
import cn.edu.fzu.sm2025.wwc.foodback.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
public class UserController {
    @Autowired
    private UserService userService;
    @PostMapping("/login")
    public String login(@RequestBody LoginRequest loginRequest) {
        return userService.login(loginRequest);
    }

    @PostMapping("/register")
    public String register(@RequestBody RegisterRequest registerRequest) {
        return userService.register(registerRequest);
    }

    //顾客改为商家
    @PostMapping("/approveApplication")
    public String approveApplication(@RequestBody Map<String, Object> request) {
        String userName = (String) request.get("userName");
        return userService.approveApplication(userName);
    }

    @GetMapping("/getUserInformation")
    public ResponseEntity<?> getUserInformation(
            @RequestParam(defaultValue = "") String userName) {
        return userService.getUserInformation(userName);
    }

    @PostMapping("/updateUserInfo")
    public ResponseEntity<?> updateUserInformation(@RequestBody NewUserDataRequest newUserDataRequest) {
        return ResponseEntity.ok(userService.updateUserInformation(newUserDataRequest));
    }
}
