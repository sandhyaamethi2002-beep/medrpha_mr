class UserFormModel {
  final String name;
  final String gstNo;
  final String phoneNo;
  final String password;
  final String email;
  final String drugsLicence;
  final String fssai;
  final String country;
  final String state;
  final String city;
  final String pinCode;
  final String address;
  final String contactPersonName;
  final String contactNumber;
  final String alternateNumber;

  UserFormModel({
    required this.name,
    required this.gstNo,
    required this.phoneNo,
    required this.password,
    required this.email,
    required this.drugsLicence,
    required this.fssai,
    required this.country,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.address,
    required this.contactPersonName,
    required this.contactNumber,
    required this.alternateNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gstNo': gstNo,
      'phoneNo': phoneNo,
      'password': password,
      'email': email,
      'drugsLicence': drugsLicence,
      'fssai': fssai,
      'country': country,
      'state': state,
      'city': city,
      'pinCode': pinCode,
      'address': address,
      'contactPersonName': contactPersonName,
      'contactNumber': contactNumber,
      'alternateNumber': alternateNumber,
    };
  }
}
