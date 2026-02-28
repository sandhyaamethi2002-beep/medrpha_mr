class GetCityByStateModel {
  final bool success;
  final String message;
  final List<CityData> data;

  GetCityByStateModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCityByStateModel.fromJson(Map<String, dynamic> json) {
    return GetCityByStateModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<CityData>.from(
          json['data'].map((x) => CityData.fromJson(x)))
          : [],
    );
  }
}

class CityData {
  final int cityid;
  final String cityName;
  final int statid;
  final int counttid;

  CityData({
    required this.cityid,
    required this.cityName,
    required this.statid,
    required this.counttid,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      /// 🔥 VERY IMPORTANT FIX
      cityid: json['cityId'] ?? json['cityid'] ?? 0,
      cityName: json['cityName'] ?? json['city_name'] ?? '',
      statid: json['statid'] ?? json['stateId'] ?? 0,
      counttid: json['counttid'] ?? json['countryId'] ?? 0,
    );
  }
}