// src/main/java/com/pcbuilder/pcbuilder/controller/UserController.java

package com.pcbuilder.pcbuilder.controller;

import com.pcbuilder.pcbuilder.config.JwtUtil;
import com.pcbuilder.pcbuilder.model.User;
import com.pcbuilder.pcbuilder.repository.UserRepository;
import com.pcbuilder.pcbuilder.service.Email_service;
import com.pcbuilder.pcbuilder.service.FileStorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/users")
public class UserController {

    private Map<String, User> pendingUsers = new ConcurrentHashMap<>();

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private Email_service emailService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private FileStorageService fileStorageService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // ==================== LOGIN ====================
    @PostMapping("/login")
    public ResponseEntity<?> login_user(@RequestBody Map<String, String> loginRequest) {
        String input = loginRequest.get("username");
        if (input == null || input.isBlank()) {
            input = loginRequest.get("email");
        }
        String password = loginRequest.get("password");

        if (input == null || password == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Missing credentials");
        }

        // If it looks like an email, normalize to lowercase for lookup (optional)
        String candidate = input.contains("@") ? input.toLowerCase() : input;

        User user = userRepo.findByUsername(candidate);
        if (user == null) {
            // for email, ensure your repository lookup is case-insensitive
            user = userRepo.findByEmail(candidate);
        }

        if (user == null || !passwordEncoder.matches(password, user.getPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid username/email or password");
        }

        long now = System.currentTimeMillis();
        long expiry = user.getExpiry() != null ? user.getExpiry() : 0;
        if (expiry < now) {
            expiry = now + (10L * 24 * 60 * 60 * 1000);
        } else {
            long remainingDays = (expiry - now) / (1000 * 60 * 60 * 24);
            long daysToAdd = 10 - remainingDays;
            expiry += daysToAdd * 24L * 60 * 60 * 1000;
        }
        user.setExpiry(expiry);
        userRepo.save(user);

        String token = jwtUtil.generateToken(user.getUsername(), expiry);

//        return ResponseEntity.ok(Map.of(
//                "token", token,
//                "expiry", expiry,
//                "username", user.getUsername(),
//                "userId", user.getId(),
//                "prof_pict", user.getProfilePicture() == null ? "/uploads/placeholder.png" : user.getProfilePicture()
//        ));
        return ResponseEntity.ok(Map.of(
                "token", token,
                "expiry", expiry,
                "username", user.getUsername(),
                "userId", user.getId(),
                "profile_picture_url",
                user.getProfilePicture() == null
                        ? "/uploads/placeholder.png"
                        : user.getProfilePicture()
        ));
    }

    // ==================== OTP (RESET PASSWORD) ====================
    @PostMapping("/request-otp")
    public ResponseEntity<?> requestOtp(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        User user = userRepo.findByEmail(email);

        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Email not registered");
        }

        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

        user.setOtp(otp);
        user.setOtpExpiry(System.currentTimeMillis() + (5 * 60 * 1000));
        userRepo.save(user);

        emailService.sendEmail(email, "Your OTP Code", "Your OTP is: " + otp);

        return ResponseEntity.ok("OTP sent to registered email");
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String otp = payload.get("otp");

        User user = userRepo.findByEmail(email);

        if (user == null || user.getOtp() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid request");
        }

        if (!otp.equals(user.getOtp())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid OTP");
        }

        if (System.currentTimeMillis() > user.getOtpExpiry()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("OTP expired");
        }

        user.setOtp(null);
        user.setOtpExpiry(null);
        userRepo.save(user);

        return ResponseEntity.ok("OTP verified, you can reset password now");
    }

    // ==================== OTP (REGISTER) ====================
    @PostMapping("/request-otp-register")
    public ResponseEntity<?> requestOtpForRegister(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String username = payload.get("username");

        if (userRepo.findByEmail(email) != null) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email already registered");
        }

        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);

        User tempUser = new User(username, email, null);
        tempUser.setOtp(otp);
        tempUser.setOtpExpiry(System.currentTimeMillis() + (5 * 60 * 1000));
        pendingUsers.put(email, tempUser);

        emailService.sendEmail(email, "Verify your email", "Your OTP is: " + otp);

        return ResponseEntity.ok("OTP sent to email");
    }

    @PostMapping("/verify-otp-register")
    public ResponseEntity<?> verifyOtpRegister(
            @RequestParam("email") String email,
            @RequestParam("otp") String otp,
            @RequestParam("password") String password,
            @RequestParam(value = "profile_picture", required = false) MultipartFile profilePictureFile) {

        User tempUser = pendingUsers.get(email);

        if (tempUser == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("No OTP request found for this email");
        }

        if (!otp.equals(tempUser.getOtp())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid OTP");
        }

        if (System.currentTimeMillis() > tempUser.getOtpExpiry()) {
            pendingUsers.remove(email);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("OTP expired");
        }

        if (profilePictureFile != null && !profilePictureFile.isEmpty()) {
            String uniqueFileName = fileStorageService.save(profilePictureFile);
            tempUser.setProfilePicture("/uploads/" + uniqueFileName);
        }

        tempUser.setPassword(passwordEncoder.encode(password));
        userRepo.save(tempUser);
        pendingUsers.remove(email);

        return ResponseEntity.ok("User registered successfully");
    }

    // ==================== RESET PASSWORD ====================
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String newPassword = payload.get("password");

        User user = userRepo.findByEmail(email);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepo.save(user);

        return ResponseEntity.ok("Password reset successful");
    }

    // ==================== LOGOUT ====================
    @PostMapping("/logout")
    public ResponseEntity<?> logoutUser() {
        return ResponseEntity.ok().body(Map.of("message", "Logged out successfully"));
    }

    // ==================== PROFILE PICTURE ====================
    @DeleteMapping("/{userId}/profile-picture")
    public ResponseEntity<?> deleteProfilePicture(@PathVariable Long userId) {
        User user = userRepo.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        String profilePicPath = user.getProfilePicture();
        if (profilePicPath == null) {
            return ResponseEntity.badRequest().body("No profile picture to delete");
        }

        try {
            fileStorageService.delete(profilePicPath);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to delete profile picture: " + e.getMessage());
        }

        user.setProfilePicture(null);
        userRepo.save(user);

        return ResponseEntity.ok("Profile picture deleted successfully");
    }

    @PostMapping("/{userId}/profile-picture")
    public ResponseEntity<?> uploadProfilePicture(
            @PathVariable Long userId,
            @RequestParam("file") MultipartFile file) {

        User user = userRepo.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        if (file == null || file.isEmpty()) {
            return ResponseEntity.badRequest().body("No file uploaded");
        }

        try {
            if (user.getProfilePicture() != null) {
                fileStorageService.delete(user.getProfilePicture());
            }

            String uniqueFileName = fileStorageService.save(file);
            user.setProfilePicture("/uploads/" + uniqueFileName);
            userRepo.save(user);

            return ResponseEntity.ok(Map.of(
                    "message", "Profile picture uploaded successfully",
                    "profile_picture_url", "/uploads/" + uniqueFileName
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to upload profile picture: " + e.getMessage());
        }
    }
    // ==================== CHANGE USERNAME ====================
    @PatchMapping("/{userId}/username")
    public ResponseEntity<?> changeUsername(
            @PathVariable Long userId,
            @RequestBody Map<String, String> payload) {

        String newUsername = payload.get("newUsername");
        if (newUsername == null || newUsername.isBlank()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Missing newUsername");
        }

        // Same validation as frontend: start with lowercase letter, then alphanumerics
        if (!newUsername.matches("^[a-z][a-z0-9]*$")) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Username must start with a lowercase letter and contain only alphanumeric characters.");
        }

        User user = userRepo.findById(userId).orElse(null);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        // No-op if unchanged
        if (newUsername.equals(user.getUsername())) {
            return ResponseEntity.ok(Map.of(
                    "message", "Username unchanged",
                    "username", user.getUsername(),
                    "token", null,
                    "expiry", user.getExpiry()
            ));
        }

        // Check availability
        if (userRepo.findByUsername(newUsername) != null) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Username already taken");
        }

        // Update + issue a fresh token (since your JWT encodes username)
        user.setUsername(newUsername);

        long now = System.currentTimeMillis();
        long expiry = user.getExpiry() != null ? user.getExpiry() : now + (10L * 24 * 60 * 60 * 1000);
        // keep existing expiry window; extend only if already expired
        if (expiry < now) {
            expiry = now + (10L * 24 * 60 * 60 * 1000);
        }
        user.setExpiry(expiry);
        userRepo.save(user);

        String newToken = jwtUtil.generateToken(user.getUsername(), expiry);

        return ResponseEntity.ok(Map.of(
                "message", "Username updated",
                "username", user.getUsername(),
                "token", newToken,
                "expiry", expiry
        ));
    }

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Not authenticated");
        }

        String username = auth.getName(); // username from JWT
        User user = userRepo.findByUsername(username);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }

        return ResponseEntity.ok(Map.of(
                "id", user.getId(),
                "username", user.getUsername(),
                "email", user.getEmail(),
                "profile_picture_url",
                user.getProfilePicture() == null
                        ? "/uploads/placeholder.png"
                        : user.getProfilePicture()
        ));
    }
}
