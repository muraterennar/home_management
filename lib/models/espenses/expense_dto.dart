import 'package:equatable/equatable.dart';
import 'expense_category.dart';

class ExpenseDto extends Equatable {
  final String? id;
  final String name;
  final double amount;
  final ExpenseCategory category; // String yerine ExpenseCategory
  final DateTime date;
  final String? tenantId;
  final String? createdBy;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? voucherUrl;

  const ExpenseDto({
    this.id,
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

  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    // Güvenli tip dönüşümlerini uygula
    String? idValue;
    if (json['id'] != null) {
      idValue = json['id'].toString();
    }

    // Tarih alanlarını güvenli şekilde parse et
    DateTime? date;
    try {
      date = json['date'] != null ? DateTime.parse(json['date']) : null;
    } catch (e) {
      date = DateTime.now();
    }

    DateTime? createdAt;
    try {
      createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    } catch (e) {
      createdAt = null;
    }

    DateTime? updatedAt;
    try {
      updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    } catch (e) {
      updatedAt = null;
    }

    DateTime? deletedAt;
    try {
      deletedAt = json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null;
    } catch (e) {
      deletedAt = null;
    }

    // Kategori alanını enum değerine dönüştür
    final categoryStr = json['category']?.toString() ?? 'other';
    final category = ExpenseCategoryExtension.fromDatabaseValue(categoryStr);

    return ExpenseDto(
      id: idValue,
      name: json['name'] ?? '',
      amount: json['amount'] is int
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: category,
      date: date ?? DateTime.now(),
      tenantId: json['tenantId']?.toString(),
      createdBy: json['createdBy']?.toString(),
      isActive: json['isActive'] ?? true,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
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
