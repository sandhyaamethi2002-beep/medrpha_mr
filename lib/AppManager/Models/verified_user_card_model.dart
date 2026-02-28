class UserCardModel {
  final String name;
  final String gstNo;
  final String phoneNo;
  final String date;
  final bool isActive;

  UserCardModel({
    required this.name,
    required this.gstNo,
    required this.phoneNo,
    required this.date,
    required this.isActive,
  });

  // Convert JSON (from API) to Model
  factory UserCardModel.fromJson(Map<String, dynamic> json) {
    return UserCardModel(
      name: json['name'] ?? '',
      gstNo: json['gst_no'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      date: json['date'] ?? '',
      isActive: json['status'] == 'Active',
    );
  }

  // Convert Model back to JSON (for API updates)
  Map<String, dynamic> toJson() => {
    'name': name,
    'gst_no': gstNo,
    'phone_no': phoneNo,
    'date': date,
    'status': isActive ? 'Active' : 'Inactive',
  };
}