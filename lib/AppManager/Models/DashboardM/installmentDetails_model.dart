class InstallmentDetailsModel {
  final int mrid;
  final String mrNm;
  final int target;
  final int monthlyinstallation;
  final int totalInstallment;
  final int monthlyInstallment;
  final int totalSale;
  final int monthlySale;

  InstallmentDetailsModel({
    required this.mrid,
    required this.mrNm,
    required this.target,
    required this.monthlyinstallation,
    required this.totalInstallment,
    required this.monthlyInstallment,
    required this.totalSale,
    required this.monthlySale,
  });

  factory InstallmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return InstallmentDetailsModel(
      mrid: json['mrid'] ?? 0,
      mrNm: json['mr_nm'] ?? "",
      target: json['target'] ?? 0,
      monthlyinstallation: json['monthlyinstallation'] ?? 0,
      totalInstallment: json['totalInstallment'] ?? 0,
      monthlyInstallment: json['monthlyInstallment'] ?? 0,
      totalSale: json['totalSale'] ?? 0,
      monthlySale: json['monthlySale'] ?? 0,
    );
  }
}