class VerifyLoginOtpModel {
  final bool? status;
  final String? message;
  final UserData? data;

  VerifyLoginOtpModel({
    this.status,
    this.message,
    this.data,
  });

  factory VerifyLoginOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyLoginOtpModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class UserData {
  final int? mrid;
  final String? mrNm;

  UserData({
    this.mrid,
    this.mrNm,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      mrid: json['mrid'],
      mrNm: json['mr_nm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mrid": mrid,
      "mr_nm": mrNm,
    };
  }
}