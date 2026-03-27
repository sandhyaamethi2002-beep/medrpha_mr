import 'package:get/get.dart';
import '../../Models/InitialUserM/GetInitialRegistrationsByMrId_model.dart';

class SaveInitialUserVM extends GetxController {

  RxBool isLoading = false.obs;

  // Reactive variable to send new user to controller
  Rx<UserData?> newUser = Rx<UserData?>(null);

  Future<UserData> sendLink(String phone) async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Create new user object
    UserData user = UserData(
      phoneno: phone,
      mrid: 1,
      completeRegStatus: 0,
    );

    isLoading.value = false;

    return user;
  }
}