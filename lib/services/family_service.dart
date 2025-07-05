import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_management/models/family/crete_family_dto.dart';
import 'package:home_management/models/family/family_dto.dart';
import 'package:home_management/models/family/update_family_dto.dart';
import 'package:home_management/services/auth_service.dart';
import 'package:home_management/l10n/app_localizations.dart';

import 'database_service.dart';

class FamilyService {
  final _authService = AuthService();
  final _databaseService = DataBaseService();

  BuildContext? context;

  // Constructor that can optionally take a BuildContext
  FamilyService([this.context]);

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

    // Aylık bütçe hesaplama (Gelir - Sabit Giderler)

    var fixedExpensesTotalAmount = family.fixedExpenses.fold<int>(
      0,
      (previousValue, element) => previousValue + (element['value'] as int? ?? 0),
    );

    family.monthlyBudget = family.familyIncome - fixedExpensesTotalAmount;

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

    // Önce mevcut aile verisini al
    final ref = _databaseService.database.ref("families/${family.tenantId}");
    final snapshot = await ref.get();
    FamilyDto? currentFamily;
    if (snapshot.exists && snapshot.value is Map<Object?, Object?>) {
      final rawMap = snapshot.value as Map<Object?, Object?>;
      final parsedMap = rawMap.map((key, value) => MapEntry(key.toString(), value));
      currentFamily = FamilyDto.fromJson(parsedMap);
    }

    // Ay değişimi veya gelir değişimi kontrolü
    bool shouldUpdateLastMonthIncome = false;
    final now = DateTime.now();
    if (currentFamily != null) {
      // Eğer ay değiştiyse veya gelir değiştiyse
      final lastUpdateMonth = currentFamily.updatedAt?.month;
      final lastUpdateYear = currentFamily.updatedAt?.year;
      if (lastUpdateMonth != now.month || lastUpdateYear != now.year) {
        shouldUpdateLastMonthIncome = true;
      } else if (currentFamily.familyIncome != family.familyIncome) {
        shouldUpdateLastMonthIncome = true;
      }
      if (shouldUpdateLastMonthIncome) {
        family = UpdateFamilyDto(
          tenantId: family.tenantId,
          name: family.name,
          familyCode: family.familyCode,
          familyIncome: family.familyIncome,
          fixedExpenses: family.fixedExpenses,
          createdAt: family.createdAt,
          createdBy: family.createdBy,
          isActive: family.isActive,
          updatedAt: now,
          deletedAt: family.deletedAt,
        );
        // lastMonthIncome'u güncelle
        await ref.update({
          'lastMonthIncome': currentFamily.familyIncome
        });
      }
    }

    family.updatedAt = _databaseService.getCurrentDate();
    await ref.update(family.toJson());

    final updatedSnapshot = await ref.get();
    if (updatedSnapshot.exists && updatedSnapshot.value is Map<Object?, Object?>) {
      final rawMap = updatedSnapshot.value as Map<Object?, Object?>;
      final parsedMap = rawMap.map((key, value) => MapEntry(key.toString(), value));
      return FamilyDto.fromJson(parsedMap);
    } else {
      throw Exception("Updated family data is not in expected format");
    }
  }

  String _generateUniqueFamilyCode() {
    final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
    return random.toString().padLeft(6, '0');
  }

  // Davet kodu ile aile bulma
  Future<FamilyDto> getFamilyByCode(String familyCode) async {
    // Mevcut kullanıcıyı al
    final user = await _getCurrentUserCredential();
    if (user == null) {
      final l10n = context != null ? AppLocalizations.of(context!) : null;
      throw Exception(l10n?.tenantIdNotFound ?? "Kullanıcı oturumu açık değil");
    }

    try {
      // Tüm aileleri listeleyen referans
      final ref = _databaseService.database.ref("families");

      // familyCode'a göre filtreleme yapıyoruz
      // Firebase orderByChild ve equalTo kullanarak filtreleme yapalım
      final query = ref.orderByChild("familyCode").equalTo(familyCode);

      // Sorguyu çalıştır
      final snapshot = await query.get();

      if (!snapshot.exists || snapshot.children.isEmpty) {
        final l10n = context != null ? AppLocalizations.of(context!) : null;
        throw Exception(l10n?.invalidInvitationCode ?? "Bu davet koduyla eşleşen bir aile bulunamadı");
      }

      // İlk eşleşen aileyi al
      final familyData = snapshot.children.first;

      if (familyData.value is Map<Object?, Object?>) {
        final rawMap = familyData.value as Map<Object?, Object?>;
        final parsedMap = rawMap.map((key, value) => MapEntry(key.toString(), value));
        return FamilyDto.fromJson(parsedMap);
      } else {
        throw Exception("Aile verileri beklenen formatta değil");
      }
    } catch (e) {
      if (e.toString().contains("Bu davet koduyla eşleşen bir aile bulunamadı")) {
        throw e;
      } else {
        throw Exception("Aile aranırken bir hata oluştu: $e");
      }
    }
  }
}
