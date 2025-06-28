class FamilyDto {
  String? id;
  String name;
  String? tenantId;
  String? familyCode;
  dynamic monthlyBudget; // double veya int olabilir, veya null olabilir
  int familyIncome; // Eklendi
  List<Map<String, dynamic>> fixedExpenses; // Eklendi
  String? currencyCode;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isActive;

  FamilyDto({
    this.id,
    required this.name,
    this.tenantId,
    this.familyCode,
    this.monthlyBudget,
    this.familyIncome = 0, // Varsayılan değer
    this.fixedExpenses = const [], // Varsayılan değer
    this.currencyCode,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  factory FamilyDto.fromJson(Map<String, dynamic> json) {
    // fixedExpenses alanı için JSON dönüşümü
    List<Map<String, dynamic>> expenses = [];
    if (json['fixedExpenses'] != null) {
      if (json['fixedExpenses'] is List) {
        expenses = List<Map<String, dynamic>>.from(
          (json['fixedExpenses'] as List).map((item) {
            if (item is Map) {
              return Map<String, dynamic>.from(item as Map);
            }
            return <String, dynamic>{};
          }),
        );
      }
    }

    return FamilyDto(
      id: json['id'],
      name: json['name'],
      tenantId: json['tenantId'],
      familyCode: json['familyCode'],
      monthlyBudget: json['monthlyBudget'],
      familyIncome: json['familyIncome'] != null
          ? int.tryParse(json['familyIncome'].toString()) ?? 0
          : 0,
      fixedExpenses: expenses,
      currencyCode: json['currencyCode'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tenantId': tenantId,
      'familyCode': familyCode,
      'monthlyBudget': monthlyBudget,
      'familyIncome': familyIncome,
      'fixedExpenses': fixedExpenses,
      'currencyCode': currencyCode,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }
}