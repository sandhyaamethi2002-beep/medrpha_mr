import 'package:flutter/material.dart';
import '../../Models/RegistrationM/get_firm_by_mrid_model.dart';
import '../../Services/RegistartionS/get_firm_by_mrid_service.dart';

class GetFirmByMridVM extends ChangeNotifier {
  final GetFirmByMridService _service = GetFirmByMridService();

  List<FirmData> firmList = [];
  List<FirmData> originalList = [];
  bool isLoading = false;

  int? savedMrId;

  /// FETCH DATA FROM API
  Future<void> fetchFirms(int mrId) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getFirmByMrId(mrId);

    if (response != null && response.data != null) {
      firmList = response.data!;
      originalList = List.from(firmList);
      savedMrId = mrId;
    }

    isLoading = false;
    notifyListeners();
  }

  /// --- UPDATED SEARCH BY FIRM NAME WITH TRIM ---
  void searchFirm(String value) {
    // 1. Sabse pehle input ko trim karein taaki faltu spaces hat jayein
    String cleanQuery = value.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      // Agar sirf spaces hain ya khali hai, toh original list dikhao
      firmList = List.from(originalList);
    } else {
      firmList = originalList.where((firm) {
        // 2. Firm name ko lowercase karke check karein
        final name = firm.firmName?.toLowerCase() ?? "";
        return name.contains(cleanQuery);
      }).toList();
    }

    notifyListeners();
  }

  /// FILTER BY DATE
  void filterByDate(DateTime date) {
    firmList = originalList.where((firm) {
      if (firm.registerDate == null) return false;

      DateTime apiDate = DateTime.parse(firm.registerDate!);

      return apiDate.year == date.year &&
          apiDate.month == date.month &&
          apiDate.day == date.day;
    }).toList();

    notifyListeners();
  }

  /// RESET FILTER
  void resetFilter() {
    firmList = List.from(originalList);
    notifyListeners();
  }
}