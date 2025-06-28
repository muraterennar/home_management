import 'package:equatable/equatable.dart';

class ExpenseDto extends Equatable {
  final String? id; // Eklenen id alanı
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
      'id': id, // Eklenen id alanı
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
    // Güvenli tip dönüşümlerini uygula
    String? idValue;
    if (json['id'] != null) {
      idValue = json['id'].toString(); // Integer olsa bile string'e çevir
    }

    // amount değerini güvenli bir şekilde double'a dönüştür
    double amountValue = 0.0;
    if (json['amount'] != null) {
      if (json['amount'] is double) {
        amountValue = json['amount'];
      } else if (json['amount'] is int) {
        amountValue = (json['amount'] as int).toDouble();
      } else {
        // String veya başka bir tip olması durumunda
        try {
          amountValue = double.parse(json['amount'].toString());
        } catch (e) {
          print('Error converting amount to double: $e');
        }
      }
    }

    // Tarih dönüşümü
    DateTime dateValue;
    try {
      if (json['date'] is DateTime) {
        dateValue = json['date'];
      } else if (json['date'] is String) {
        dateValue = DateTime.parse(json['date']);
      } else {
        dateValue = DateTime.now();
        print('Date not in expected format, using current date');
      }
    } catch (e) {
      dateValue = DateTime.now();
      print('Error parsing date: $e');
    }

    // Diğer alanların güvenli bir şekilde dönüştürülmesi
    return ExpenseDto(
      id: idValue,
      name: json['name']?.toString() ?? 'Unnamed Expense',
      amount: amountValue,
      date: dateValue,
      category: json['category']?.toString() ?? 'Other',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is DateTime
              ? json['createdAt']
              : DateTime.parse(json['createdAt'].toString()))
          : DateTime.now(),
      createdBy: json['createdBy']?.toString(),
      tenantId: json['tenantId']?.toString(),
      voucherUrl: json['voucherUrl']?.toString(),
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
