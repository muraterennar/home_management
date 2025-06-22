import 'package:equatable/equatable.dart';

class UserDto extends Equatable {
  String id;
  String email;
  String? firstName;
  String? lastName;
  String? photoURL;
  String? tenantId;
  DateTime createdAt;
  DateTime? updatedAt;
  String? createdBy;
  bool isActive;

  UserDto({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.photoURL,
    this.tenantId,
    DateTime? createdAt,
    this.updatedAt,
    this.createdBy,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        photoURL,
        tenantId,
        createdAt,
        updatedAt,
        createdBy,
        isActive,
      ];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photoURL': photoURL,
      'tenantId': tenantId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'isActive': isActive,
    };
  }

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photoURL: json['photoURL'] as String?,
      tenantId: json['tenantId'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      createdBy: json['createdBy'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
