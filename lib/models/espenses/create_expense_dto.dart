import 'package:equatable/equatable.dart';
import 'expense_category.dart';

class CreateExpenseDto extends Equatable {
  String id; // int? yerine String yapıyoruz
  String name;
  double amount;
  ExpenseCategory category; // String yerine ExpenseCategory
  DateTime date;
  String? tenantId;
  String? createdBy;
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  String? voucherUrl;

  CreateExpenseDto({
    String? id,
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
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category.toDatabaseValue(), // Enum'dan string'e dönüşüm
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
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: ExpenseCategoryExtension.fromDatabaseValue(json['category'] ?? 'other'), // String'den enum'a dönüşüm
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      tenantId: json['tenantId']?.toString(),
      createdBy: json['createdBy']?.toString(),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      voucherUrl: json['voucherUrl']?.toString(),
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
        deletedAt,
        voucherUrl,
      ];
}
