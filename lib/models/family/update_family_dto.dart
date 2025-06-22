import 'package:flutter/cupertino.dart';

class UpdateFamilyDto {
  final String Id = UniqueKey().toString();
  String? tenantId;
  String name;
  String? familyCode;
  int familyIncome;
  List<Map<String, dynamic>> fixedExpenses;
  String? createdBy;
  bool? isActive = true;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  UpdateFamilyDto({
    this.tenantId,
    required this.name,
    this.familyCode,
    required this.familyIncome,
    required this.fixedExpenses,
    this.createdAt,
    this.createdBy,
    this.isActive,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'UpdateFamilyDto(name: $name, familyIncome: $familyIncome, familyCode: $familyCode, fixedExpenses: $fixedExpenses, createdBy: $createdBy, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, tenantId: $tenantId)';
  }

  @override
  List<Object> get props => [
    Id,
    name,
    familyCode ?? '',
    familyIncome,
    fixedExpenses,
    createdBy ?? '',
    isActive ?? true,
    createdAt ?? '',
    updatedAt ?? '',
    deletedAt ?? '',
    tenantId ?? ''
  ];

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'tenantId': tenantId,
      'familyCode': familyCode,
      'name': name,
      'familyIncome': familyIncome,
      'fixedExpenses': fixedExpenses,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'createdBy': createdBy,

      // Assuming this is the user who created the family
    };
  }

  factory UpdateFamilyDto.fromJson(Map<String, dynamic> json) {
    return UpdateFamilyDto(
      tenantId: json['tenantId'] as String,
      name: json['name'] as String,
      familyIncome: json['familyIncome'] as int,
      familyCode: json['familyCode'] as String?,
      fixedExpenses:
      List<Map<String, dynamic>>.from(json['fixedExpenses'] ?? []),
      createdBy: json['createdBy'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
    );
  }
}
