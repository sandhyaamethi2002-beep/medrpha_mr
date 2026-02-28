class GetPincodeByCityModel {
  final bool success;
  final String message;
  final List<AreaData> data;

  GetPincodeByCityModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetPincodeByCityModel.fromJson(Map<String, dynamic> json) {
    return GetPincodeByCityModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<AreaData>.from(
          json['data'].map((x) => AreaData.fromJson(x)))
          : [],
    );
  }
}

class AreaData {
  final int areaid;
  final int counttid;
  final int statid;
  final int cityid;
  final String areaName;
  final int commission;
  final int comid;

  AreaData({
    required this.areaid,
    required this.counttid,
    required this.statid,
    required this.cityid,
    required this.areaName,
    required this.commission,
    required this.comid,
  });

  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
      areaid: json['areaid'] ?? 0,
      counttid: json['counttid'] ?? 0,
      statid: json['statid'] ?? 0,
      cityid: json['cityid'] ?? 0,
      areaName: json['area_name'] ?? '',
      commission: json['commission'] ?? 0,
      comid: json['comid'] ?? 0,
    );
  }
}