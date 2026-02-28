import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialUserModel {
  final String phone;
  bool isCompleted;

  InitialUserModel({
    required this.phone,
    this.isCompleted = false,
  });
}

class InitialUserController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  // Master list (Reactive)
  final RxList<InitialUserModel> _allUsers = <InitialUserModel>[
    InitialUserModel(phone: "123-456-7890"),
    InitialUserModel(phone: "098-765-4321"),
    InitialUserModel(phone: "555-555-5555"),
    InitialUserModel(phone: "111-222-3333"),
    InitialUserModel(phone: "987-654-3210"),
    InitialUserModel(phone: "123-123-1234"),
    InitialUserModel(phone: "456-789-0123"),
    InitialUserModel(phone: "888-999-0000"),
    InitialUserModel(phone: "222-333-4444"),
    InitialUserModel(phone: "666-777-8888"),
    InitialUserModel(phone: "333-444-5555"),
    InitialUserModel(phone: "777-888-9999"),
    InitialUserModel(phone: "444-555-6666"),
    InitialUserModel(phone: "888-999-1111"),
    InitialUserModel(phone: "555-666-7777"),
  ].obs;

  // Filtered list (UI me show hoga)
  final RxList<InitialUserModel> filteredUsers =
      <InitialUserModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Initially show all users
    filteredUsers.assignAll(_allUsers);

    // Add listener for search
    searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      filteredUsers.assignAll(_allUsers);
    } else {
      filteredUsers.assignAll(
        _allUsers.where(
              (user) => user.phone.toLowerCase().contains(query),
        ),
      );
    }
  }

  void completeRegistration(InitialUserModel user) {
    user.isCompleted = true;

    // Refresh main list so UI updates
    _allUsers.refresh();

    // Re-apply filter
    _filterUsers();
  }

  @override
  void onClose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.onClose();
  }
}
