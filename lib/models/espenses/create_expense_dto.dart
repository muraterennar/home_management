import 'package:equatable/equatable.dart';

class CreateExpenseDto extends Equatable {
  int? id;
  String name;
  double amount;
  String category;
  DateTime date;
  String? tenantId;
  String? createdBy;
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? voucherUrl;

  CreateExpenseDto({
    int? id,
    this.tenantId,
    this.createdBy,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.voucherUrl,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'tenantId': tenantId,
      'createdBy': createdBy,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'voucherUrl': voucherUrl,
    };
  }

  factory CreateExpenseDto.fromJson(Map<String, dynamic> json) {
    return CreateExpenseDto(
      id: json['id'] as int?,
      tenantId: json['tenantId'] as String?,
      createdBy: json['createdBy'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      date: DateTime.parse(json['date']),
      voucherUrl: json['voucherUrl'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        category,
        date,
        tenantId,
        createdBy,
        isActive,
        createdAt,
        updatedAt,
        deletedAt
      ];
}
