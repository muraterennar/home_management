import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:home_management/models/users/create_user_dto.dart';
import 'package:home_management/models/users/user_dto.dart';
import 'package:home_management/services/auth_service.dart';

import 'database_service.dart';

class UserService {
  final _authService = AuthService();
  final _databaseService = DataBaseService();

  Future<String> getCurrentUserId() async {
    try {
      // Attempt to get the current user
      final user = await _authService.getCurrentUser();
      debugPrint("Current User: ${user?.uid ?? 'null'}");
      if (user == null) {
        throw Exception("User not authenticated");
      }

      return user.uid;
    } catch (e) {
      debugPrint("Error getting current user: $e");
      throw Exception("Failed to get current user");
    }
  }

  // Set User Profile
  Future<UserDto> createUserProfile(CreateUserDto userDto) async {
    try {
      final userId = await getCurrentUserId();
      userDto.id = userId;
      userDto.createdAt = _databaseService.getCurrentDate();

      final ref = _databaseService.database.ref("users/$userId");
      await ref.set(userDto.toJson());

      // CreateUserDto'dan UserDto oluştur
      return UserDto.fromJson(userDto.toJson());
    } catch (e) {
      debugPrint("Kullanıcı profili oluşturulurken hata: $e");
      throw Exception("Kullanıcı profili oluşturulamadı: $e");
    }
  }

  // Update User Profile
  Future<UserDto> updateUserProfile(UserDto userDto) async {
    final userId = await getCurrentUserId();
    userDto.id = userId;
    userDto.updatedAt = _databaseService.getCurrentDate();

    final ref = _databaseService.database.ref("users/$userId");
    await ref.update(userDto.toJson());

    return userDto;
  }

  Future<UserDto> setTenantId(String tenantId) async {
    final userId = await getCurrentUserId();
    final ref = _databaseService.database.ref("users/$userId");
    await ref.update({"tenantId": tenantId});

    // Return the updated user profile
    return getUserById(userId);
  }

  Future<String> getTenantId() async {
    final user = await getCurrentUserProfile();
    if (user == null) {
      return "";
    }
    return user.tenantId!;
  }

  Future<UserDto> getUserById(String id) async {
    final ref = _databaseService.database.ref("users/$id");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final rawData = Map<Object?, Object?>.from(snapshot.value as Map);
      final json = rawData.map((key, value) => MapEntry(key.toString(), value));
      return UserDto.fromJson(json);
    } else {
      throw Exception("User not found with id: $id");
    }
  }

  Future<UserDto> getCurrentUserProfile() async {
    final userId = await getCurrentUserId();
    return getUserById(userId);
  }

  Future<UserDto?> getUserProfileByEmail(String email) async {
    if (email.isEmpty) {
      throw Exception("Email cannot be empty");
    }

    final ref = _databaseService.database.ref("users");
    final snapshot = await ref.orderByChild('email').equalTo(email).get();

    if (snapshot.exists) {
      final dataMap = snapshot.value as Map<dynamic, dynamic>;
      if (dataMap.isEmpty) {
        return null;
      }

      final firstKey = dataMap.keys.first;
      final userData = Map<String, dynamic>.from(dataMap[firstKey] as Map);

      return UserDto.fromJson(userData);
    } else {
      return null;
    }
  }
}
