class GetFirmByMridModel {
  bool? status;
  List<FirmData>? data;

  GetFirmByMridModel({this.status, this.data});

  GetFirmByMridModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FirmData>[];
      json['data'].forEach((v) {
        data!.add(FirmData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FirmData {
  int? firmId;
  String? firmName;
  String? gstno;
  String? phoneno;
  String? registerDate;
  int? status;
  String? hdnDrugsyesno;
  String? address;
  int? adminId;
  int? userTypeId;

  FirmData({
    this.firmId,
    this.firmName,
    this.gstno,
    this.phoneno,
    this.registerDate,
    this.status,
    this.hdnDrugsyesno,
    this.address,
    this.adminId,
    this.userTypeId,
  });

  FirmData.fromJson(Map<String, dynamic> json) {
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    gstno = json['gstno'];
    phoneno = json['phoneno'];
    registerDate = json['register_date'];
    status = json['status'];
    hdnDrugsyesno = json['hdnDrugsyesno']?.toString();
    address = json['address'];
    adminId: json['adminId'] ?? json['admin_id'] ?? 1;
    userTypeId: json['userTypeId'] ?? json['user_type_id'] ?? 1;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['gstno'] = gstno;
    data['phoneno'] = phoneno;
    data['register_date'] = registerDate;
    data['status'] = status;
    data['hdnDrugsyesno'] = hdnDrugsyesno;
    data['address'] = address;
    return data;
  }
}