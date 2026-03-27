import 'package:get/get.dart';
import '../../Models/ProfileM/get_mr_by_id_model.dart';
import '../../Services/ProfileS/get_mr_by_id_service.dart';

class GetMrByIdController extends GetxController {
  var isLoading = false.obs;
  var mrData = Rxn<MrData>();

  final GetMrByIdService _service = GetMrByIdService();

  Future<void> fetchMr(int mrId) async {
    try {
      isLoading.value = true;

      final response = await _service.getMrById(mrId);

      if (response != null) {
        final model = GetMrByIdModel.fromJson(response);

        if (model.data != null && model.data!.isNotEmpty) {
          mrData.value = model.data!.first;
        }
      }
    } catch (e) {
      print(" Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}