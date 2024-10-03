class FcmToken {
  String? userPhone;
  String? fcmToken;

  FcmToken({this.userPhone, this.fcmToken});

  factory FcmToken.fromJson(Map<String, dynamic> json) {
    return FcmToken(
      userPhone: json['userPhone'] as String,
      fcmToken: json['fcmToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userPhone'] = this.userPhone;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
