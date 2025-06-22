import 'package:equatable/equatable.dart';

class RegisterDto extends Equatable {
  String email;
  String password;
  String? firstName;
  String? lastName;
  String? photoURL;
  String? tenantId;

  RegisterDto({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
    this.photoURL,
    this.tenantId
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, photoURL, tenantId];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'photoURL': photoURL,
      'tenantId': tenantId,
    };
  }

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photoURL: json['photoURL'] as String?,
      tenantId: json['tenantId'] as String?,
    );
  }
}
