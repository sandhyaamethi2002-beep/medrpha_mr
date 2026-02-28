class GetStatesByCountryModel {
  final bool success;
  final String message;
  final List<StateData> data;

  GetStatesByCountryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetStatesByCountryModel.fromJson(Map<String, dynamic> json) {
    return GetStatesByCountryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => StateData.fromJson(e))
          .toList(),
    );
  }
}

class StateData {
  final int stateid;
  final String stateName;
  final int countid;

  StateData({
    required this.stateid,
    required this.stateName,
    required this.countid,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      stateid: json['stateid'],
      stateName: json['state_name'],
      countid: json['countid'],
    );
  }
}