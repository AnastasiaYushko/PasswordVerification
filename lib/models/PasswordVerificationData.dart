
class PasswordVerificationData {
  final String passwordMask;
  final int lengthPassword;

  const PasswordVerificationData(
      {required this.passwordMask, required this.lengthPassword});

  factory PasswordVerificationData.fromJson(Map<String, dynamic> json) {
    return PasswordVerificationData(
      passwordMask: json['passwordMask'],
      lengthPassword: json['lengthPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passwordMask'] = passwordMask;
    data['lengthPassword'] = lengthPassword;
    return data;
  }
}