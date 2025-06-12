package cn.edu.fzu.sm2025.wwc.foodback.service;

import cn.edu.fzu.sm2025.wwc.foodback.dto.LoginRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.NewUserDataRequest;
import cn.edu.fzu.sm2025.wwc.foodback.dto.RegisterRequest;
import org.springframework.http.ResponseEntity;

public interface UserService {
    String login(LoginRequest loginRequest);

    String register(RegisterRequest registerRequest);

    String approveApplication(String userName);

    ResponseEntity<?> getUserInformation(String userName);

    ResponseEntity<?> updateUserInformation(NewUserDataRequest newUserDataRequest);
}
