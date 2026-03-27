import 'package:get/get.dart';

import '../../Models/InitialUserM/GetInitialRegistrationsByMrId_model.dart';
import '../../Services/InitialUserS/GetInitialRegistrationsByMrId_service.dart';


class GetInitialRegistrationsByMrIdVM extends GetxController {

  final GetInitialRegistrationsByMrIdService service =
  GetInitialRegistrationsByMrIdService();

  RxList<UserData> users = <UserData>[].obs;

  RxBool isLoading = false.obs;

  Future<void> fetchUsers(int mrid) async {

    try {

      isLoading.value = true;

      final response = await service.getUsers(mrid);

      if (response != null && response.status == true) {

        users.assignAll(response.data ?? []);

      } else {
        users.clear();
      }

    } catch (e) {
      print("VM ERROR : $e");
    } finally {
      isLoading.value = false;
    }
  }
}