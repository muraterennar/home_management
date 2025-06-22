class FamilyDto {
  final String tenantId;
  String name;
  int familyIncome;
  List<Map<String, dynamic>> fixedExpenses;
  String? familyId;
  String? createdBy;
  bool? isActive = true;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;


  FamilyDto({
    required this.tenantId,
    required this.name,
    required this.familyIncome,
    required this.fixedExpenses,
    this.familyId,
    this.createdBy,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'FamilyDto(tenantId: $tenantId, name: $name, familyIncome: $familyIncome, fixedExpenses: $fixedExpenses, familyId: $familyId, createdBy: $createdBy, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }


  Map<String, dynamic> toJson() {
    return {
      'tenantId': tenantId,
      'name': name,
      'familyIncome': familyIncome,
      'fixedExpenses': fixedExpenses,
      'familyId': familyId,
      'createdBy': createdBy,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory FamilyDto.fromJson(Map<String, dynamic> json) {
    return FamilyDto(
      tenantId: json['tenantId'] as String,
      name: json['name'] as String,
      familyIncome: json['familyIncome'] as int,
      fixedExpenses: List<Map<String, dynamic>>.from(
        (json['fixedExpenses'] as List).map((e) =>
        Map<String, dynamic>.from(e)),
      ),
      familyId: json['familyId'] as String?,
      createdBy: json['createdBy'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}