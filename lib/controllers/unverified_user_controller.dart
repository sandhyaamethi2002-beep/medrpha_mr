import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnverifiedUserModel {
  final String phone;
  bool isCompleted;

  UnverifiedUserModel({
    required this.phone,
    this.isCompleted = false,
  });
}

class UnverifiedUserController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  // Master list (Reactive)
  final RxList<UnverifiedUserModel> _allUsers = <UnverifiedUserModel>[
    UnverifiedUserModel(phone: "123-456-7890"),
    UnverifiedUserModel(phone: "098-765-4321"),
    UnverifiedUserModel(phone: "555-555-5555"),
    UnverifiedUserModel(phone: "111-222-3333"),
    UnverifiedUserModel(phone: "987-654-3210"),
    UnverifiedUserModel(phone: "123-123-1234"),
    UnverifiedUserModel(phone: "456-789-0123"),
    UnverifiedUserModel(phone: "888-999-0000"),
    UnverifiedUserModel(phone: "222-333-4444"),
    UnverifiedUserModel(phone: "666-777-8888"),
    UnverifiedUserModel(phone: "333-444-5555"),
    UnverifiedUserModel(phone: "777-888-9999"),
    UnverifiedUserModel(phone: "444-555-6666"),
    UnverifiedUserModel(phone: "888-999-1111"),
    UnverifiedUserModel(phone: "555-666-7777"),
  ].obs;

  // Filtered list (UI me show hoga)
  final RxList<UnverifiedUserModel> filteredUsers =
      <UnverifiedUserModel>[].obs;

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

  void completeRegistration(UnverifiedUserModel user) {
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
