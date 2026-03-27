class SaveInitialUserModel {
  bool? status;
  String? message;

  SaveInitialUserModel({this.status, this.message});

  SaveInitialUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}