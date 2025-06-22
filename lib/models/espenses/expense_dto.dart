import 'package:equatable/equatable.dart';

class ExpenseDto extends Equatable {
  final String name;
  final double amount;
  final String category;
  final DateTime date;
  final String? tenantId;
  final String? createdBy;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? voucherUrl;

  const ExpenseDto({
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
  });

  Map<String, dynamic> toJson() {
    return {
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

  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    return ExpenseDto(
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
