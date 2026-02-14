import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserModel {
  final String firmName;
  final String gstNo;
  final String phoneNo;
  final String date;
  final bool isActive;

  UserModel({
    required this.firmName,
    required this.gstNo,
    required this.phoneNo,
    required this.date,
    required this.isActive,
  });
}

class VerifiedUserController extends GetxController {
  final searchController = TextEditingController();

  final _allUsers = <UserModel>[
    UserModel(
      firmName: "Vikas Gupta",
      gstNo: "29ABCDE1234F1Z5",
      phoneNo: "+91 987 654 3210",
      date: "28-07-2024",
      isActive: true,
    ),
    UserModel(
      firmName: "Priya Singh",
      gstNo: "27FGHIJ5678K1Z4",
      phoneNo: "+91 876 543 2109",
      date: "27-07-2024",
      isActive: false,
    ),
    UserModel(
      firmName: "Amit Kumar",
      gstNo: "07AAAAA0000A1Z5",
      phoneNo: "+91 998 877 6655",
      date: "26-07-2024",
      isActive: true,
    ),
    UserModel(
      firmName: "Sunita Sharma",
      gstNo: "08BBBBB1111B1Z4",
      phoneNo: "+91 887 766 5544",
      date: "25-07-2024",
      isActive: false,
    ),
    UserModel(
      firmName: "Rajesh Patel",
      gstNo: "09CCCCC2222C1Z3",
      phoneNo: "+91 776 655 4433",
      date: "24-07-2024",
      isActive: true,
    ),
    UserModel(
      firmName: "Kavita Reddy",
      gstNo: "10DDDDD3333D1Z2",
      phoneNo: "+91 665 544 3322",
      date: "23-07-2024",
      isActive: false,
    ),
    UserModel(
      firmName: "Suresh Mehta",
      gstNo: "11EEEEE4444E1Z1",
      phoneNo: "+91 554 433 2211",
      date: "22-07-2024",
      isActive: true,
    ),
  ].obs;

  final filteredUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredUsers.assignAll(_allUsers);
    searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredUsers.assignAll(_allUsers);
    } else {
      filteredUsers.assignAll(_allUsers.where((user) =>
          user.firmName.toLowerCase().contains(query)));
    }
  }

  // Public method to add a user, which also updates the filtered list
  void addUser(UserModel user) {
    _allUsers.add(user);
    _filterUsers(); // Re-apply filter to include the new user if it matches
  }

  @override
  void onClose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.onClose();
  }
}
