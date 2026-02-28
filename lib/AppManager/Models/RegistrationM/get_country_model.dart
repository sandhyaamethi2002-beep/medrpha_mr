class GetCountryModel {
  final bool success;
  final String message;
  final List<CountryData> data;

  GetCountryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCountryModel.fromJson(Map<String, dynamic> json) {
    return GetCountryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => CountryData.fromJson(e))
          .toList(),
    );
  }
}

class CountryData {
  final int countryId;
  final String countryName;
  final String? countryCode;
  final int isActive;

  CountryData({
    required this.countryId,
    required this.countryName,
    this.countryCode,
    required this.isActive,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      countryId: json['countryid'] ?? 0,
      countryName: json['country_name'] ?? '',
      countryCode: json['country_code'],
      isActive: json['isactive'] ?? 0,
    );
  }
}