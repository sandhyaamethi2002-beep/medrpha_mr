class GetMrByIdModel {
  bool? status;
  List<MrData>? data;

  GetMrByIdModel({this.status, this.data});

  GetMrByIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MrData>[];
      json['data'].forEach((v) {
        data!.add(MrData.fromJson(v));
      });
    }
  }
}

class MrData {
  int? mrid;
  String? mrNm;
  String? mrmobile;
  String? mrAlternate;
  String? mremail;
  String? mrUnm;
  String? mrPs;
  String? mrstatus;
  String? mrAddress;
  int? target;
  int? adminId;
  int? hdnDes_id;

  MrData.fromJson(Map<String, dynamic> json) {
    mrid = json['mrid'];
    mrNm = json['mr_nm'];
    mrmobile = json['mrmobile'];
    mrAlternate = json['mrAlternate'];
    mremail = json['mremail'];
    mrUnm = json['mr_unm'];
    mrPs = json['mr_ps'];
    mrstatus = json['mrstatus'];
    mrAddress = json['mrAddress'];
    target = json['target'];
    adminId = json['adminId'];
    hdnDes_id = json['hdnDes_id'];
  }
}