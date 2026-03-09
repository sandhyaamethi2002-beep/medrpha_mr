class ApiConstants {
  static const String baseUrl = "https://mrnew.medrpha.com/api";

  // Fee APIs
  static const String saveFeeCollection = "$baseUrl/FeeApi/SaveFeeCollection";
  static const String getAllSuggestion = "$baseUrl/FeeApi/GetAllSuggestion";
  static const String FeeReceivedSummary = "$baseUrl/FeeApi/FeeReceivedSummary";
  static const String StudentMonthlyPendingFee = "$baseUrl/FeeApi/StudentMonthlyPendingFee";

  //Account APIs
  static const String login = "$baseUrl/AuthApi/login";


  // Attendance
  static const String getStudentAttendance = "$baseUrl/StudentApi/GetStudentAttendance";
  static const String GetTimeTableByClass = "$baseUrl/StudentApi/GetTimeTableByClass";
  static const String GetStudentInfoById = "$baseUrl/StudentApi/GetStudentInfoById";
  static const String ChangeStudentPassword = "$baseUrl/StudentApi/ChangeStudentPassword";

}