class GetInitialRegistrationsByMrIdModel {
  bool? status;
  List<UserData>? data;

  GetInitialRegistrationsByMrIdModel({this.status, this.data});

  GetInitialRegistrationsByMrIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
  }
}

class UserData {
  String? phoneno;
  int? mrid;
  int? completeRegStatus;

  UserData({this.phoneno, this.mrid, this.completeRegStatus});

  UserData.fromJson(Map<String, dynamic> json) {
    phoneno = json['phoneno'];
    mrid = json['mrid'];
    completeRegStatus = json['complete_reg_status'];
  }
}