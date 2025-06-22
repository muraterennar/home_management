import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_management/models/family/crete_family_dto.dart';
import 'package:home_management/models/family/family_dto.dart';
import 'package:home_management/models/family/update_family_dto.dart';
import 'package:home_management/services/auth_service.dart';

import 'database_service.dart';

class FamilyService {
  final _authService = AuthService();
  final _databaseService = DataBaseService();

  Future<User?> _getCurrentUserCredential() async {
    final user = await _authService.getCurrentUser();
    return user;
  }

  // Get Family By Tenant ID
  Future<FamilyDto> getFamilyByTenantId(String tenantId) async {
    final ref = _databaseService.database.ref("families/$tenantId");
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final rawMap = snapshot.value as Map<Object?, Object?>;
      final parsedMap =
          rawMap.map((key, value) => MapEntry(key.toString(), value));
      return FamilyDto.fromJson(parsedMap);
    } else {
      throw Exception("Family not found for tenant ID: $tenantId");
    }
  }

  // Create a new family
  Future<CreateFamilyDto> createFamily(CreateFamilyDto family) async {
    final user = await _getCurrentUserCredential();
    if (user == null) {
      throw Exception("User not authenticated");
    }

    String code = _generateUniqueFamilyCode();
    family.familyCode = code;
    final tenantId = "${family.name.replaceAll(' ', '').toLowerCase()}_$code";
    family.tenantId = tenantId;
    family.createdBy = user.uid;
    family.createdAt = _databaseService.getCurrentDate();
    family.isActive = true;

    final ref = _databaseService.database.ref("families/$tenantId");
    await ref.set(family.toJson());

    return family;
  }

  // Update a family
  Future<FamilyDto> updateFamily(UpdateFamilyDto family) async {
    final user = await _getCurrentUserCredential();
    if (user == null) {
      throw Exception("User not authenticated");
    }

    family.updatedAt = _databaseService.getCurrentDate();

    final ref = _databaseService.database.ref("families/${family.tenantId}");
    await ref.update(family.toJson());

    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final rawMap = snapshot.value as Map<Object?, Object?>;
      final parsedMap =
          rawMap.map((key, value) => MapEntry(key.toString(), value));
      return FamilyDto.fromJson(parsedMap);
    } else {
      throw Exception("Updated family data is not in expected format");
    }
  }

  String _generateUniqueFamilyCode() {
    final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
    return random.toString().padLeft(6, '0');
  }

// Update family details
}
