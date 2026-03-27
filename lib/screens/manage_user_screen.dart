import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/CategoryVM/getByCategoryId_vm.dart';
import '../AppManager/ViewModel/CategoryVM/getProductDetail_vm.dart';
import '../AppManager/ViewModel/RegistrationVM/get_firm_by_mrid_vm.dart';
import '../screens/product_screen.dart';
import '../screens/view_user_detail.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/add_user_screen.dart';
import '../widgets/verified_user_card.dart';

class VerifiedUserScreen extends StatefulWidget {
  final int mrId;

  const VerifiedUserScreen({super.key, required this.mrId});

  @override
  State<VerifiedUserScreen> createState() => _VerifiedUserScreenState();
}

class _VerifiedUserScreenState extends State<VerifiedUserScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GetFirmByMridVM>().fetchFirms(widget.mrId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GetFirmByMridVM>();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
        title:
        Text("Verified Users", style: titleStyle.copyWith(color: whiteColor)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.read<GetFirmByMridVM>().fetchFirms(widget.mrId);
            },
            icon: const Icon(Icons.refresh, color: whiteColor),
          )
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),

        child: Column(
          children: [
            /// TOP SECTION
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ADD USER BUTTON
                  ElevatedButton.icon(
                    onPressed: () => Get.dialog(AddUserScreen()),
                    icon: const Icon(CupertinoIcons.add, color: whiteColor, size: 18),
                    label: Text("Add User", style: buttonTextStyle.copyWith(color: whiteColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// SEARCH + DATE UI
                  Row(
                    children: [
                      /// SEARCH
                      Flexible(
                        child: TextField(
                          style: bodyStyle,
                          onChanged: (value) {
                            context.read<GetFirmByMridVM>().searchFirm(value);
                          },
                          decoration: InputDecoration(
                            hintText: "Search by firm name...",
                            hintStyle: bodyStyle.copyWith(color: greyColor),
                            prefixIcon: const Icon(CupertinoIcons.search, color: greyColor),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      /// CALENDAR BUTTON
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );

                              if (selectedDate != null) {
                                context.read<GetFirmByMridVM>().filterByDate(selectedDate);
                              }
                            },
                            icon: const Icon(CupertinoIcons.calendar, color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// LIST SECTION
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : vm.firmList.isEmpty
                  ? const Center(child: Text("No users found"))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: vm.firmList.length,
                itemBuilder: (context, index) {
                  final firm = vm.firmList[index];
                  return VerifiedUserCard(
                    address: firm.address,
                    firmName: firm.firmName ?? "N/A",
                    gstNo: firm.gstno ?? "N/A",
                    drugLicence: firm.hdnDrugsyesno?.toString() ?? "N/A",
                    phoneNo: firm.phoneno ?? "N/A",
                    date: _formatDate(firm.registerDate),
                    // isActive: firm.status == 1,
                    isActive: firm.status == 1 && firm.hdnDrugsyesno.toString() == "1",

                    onViewDetails: () {
                      Get.dialog(
                        ViewUserDetail(
                          user: firm,
                        ),
                      );
                    },

                    onViewPrice: () {
                      // Yahan String comparison zaroori hai kyunki API se "1" ya "2" aa raha hai
                      bool isFullyActive = firm.status == 1 && firm.hdnDrugsyesno.toString() == "1";

                      if (isFullyActive) {
                        /// ACTIVE USER LOGIC
                        final productVM = Get.put(ProductDetailsViewModel());
                        productVM.getProductDetails(
                          catId: "1",
                          adminId: 1,
                          areaId: 1,
                        );

                        Get.to(() => ProductScreen(
                          firmName: firm.firmName ?? "Products",
                          firmId: firm.firmId ?? 0,
                          userId: firm.firmId ?? 0,
                          roleId: firm.adminId ?? 1,
                          userTypeId: firm.userTypeId ?? 1,
                          isViewOnly: false,
                          address: firm.address,
                          phoneno: firm.phoneno,
                        ));
                      }
                      else {
                        /// INACTIVE USER LOGIC
                        final categoryVM = context.read<GetByCategoryVM>();
                        categoryVM.fetchProducts();

                        Get.to(() => ProductScreen(
                          firmName: firm.firmName ?? "Products",
                          firmId: firm.firmId ?? 0,
                          userId: widget.mrId,
                          roleId: firm.adminId ?? 1,
                          userTypeId: firm.userTypeId ?? 1,
                          isViewOnly: true,
                          address: "${firm.address}",
                          phoneno: "${firm.phoneno}",
                        ));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";
    try {
      DateTime parsedDate = DateTime.parse(date);

      // padLeft(2, '0') ka matlab hai agar length 2 se kam hai toh aage '0' laga do
      String day = parsedDate.day.toString().padLeft(2, '0');
      String month = parsedDate.month.toString().padLeft(2, '0');
      String year = parsedDate.year.toString();

      return "$day-$month-$year"; // Output: 10-03-2022
    } catch (e) {
      return date;
    }
  }
}