import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Ensure this is imported
import '../AppManager/Models/InitialUserM/GetInitialRegistrationsByMrId_model.dart';
import '../AppManager/ViewModel/InitialUserVM/GetInitialRegistrationsByMrId_vm.dart';
import '../AppManager/ViewModel/InitialUserVM/SaveInitialUser_vm.dart';

class InitialUserController extends GetxController {
  // We no longer require mrId in the constructor.
  // It will pull dynamically from storage.
  InitialUserController();

  final TextEditingController searchController = TextEditingController();
  final box = GetStorage();

  // ViewModels
  final GetInitialRegistrationsByMrIdVM vm = Get.put(GetInitialRegistrationsByMrIdVM());
  final SaveInitialUserVM saveVm = Get.put(SaveInitialUserVM());

  // Observables
  RxList<UserData> filteredUsers = <UserData>[].obs;

  /// Helper to get the current MR ID from storage
  int get currentMrId => box.read('mr_id') ?? 0;

  @override
  void onInit() {
    super.onInit();

    // Initial fetch
    fetchUsers();

    searchController.addListener(_filterUsers);

    // Listen for new user addition from the Send Link Dialog
    ever(saveVm.newUser, (UserData? user) {
      if (user != null) {
        // Add to the local list immediately so the UI updates
        vm.users.insert(0, user);
        _filterUsers();
      }
    });
  }

  /// Fetch users using the ID from GetStorage
  void fetchUsers() async {
    if (currentMrId == 0) {
      debugPrint("Warning: mr_id is 0. Ensure user is logged in.");
    }

    await vm.fetchUsers(currentMrId);
    filteredUsers.assignAll(vm.users);
  }

  /// Search filter logic
  void _filterUsers() {
    String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      filteredUsers.assignAll(vm.users);
    } else {
      filteredUsers.assignAll(
        vm.users.where(
              (user) => (user.phoneno ?? "").toLowerCase().contains(query),
        ),
      );
    }
  }

  /// Mark registration complete locally
  void completeRegistration(UserData user) {
    user.completeRegStatus = 1;
    vm.users.refresh();
    _filterUsers();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}