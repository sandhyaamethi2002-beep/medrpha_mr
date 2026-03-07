import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppManager/ViewModel/CategoryVM/getcategory_vm.dart';
import '../AppManager/ViewModel/CategoryVM/getByCategoryId_vm.dart';

class CategoryFilter extends StatelessWidget {
  final GetCategoryVM categoryVM;
  final GetByCategoryIdVM productVM;

  const CategoryFilter({
    super.key,
    required this.categoryVM,
    required this.productVM,
  });

  @override
  Widget build(BuildContext context) {
    // Screen width se padding minus karke 3 barabar hisse (columns) banana
    double chipWidth = (MediaQuery.of(context).size.width - 60) / 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Handle Bar
          Center(
            child: Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Text(
            "Select Category",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Obx(() {
            if (categoryVM.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (categoryVM.categoryList.isEmpty) {
              return const Center(child: Text("No Categories Found"));
            }

            return Wrap(
              spacing: 10,
              runSpacing: 12,
              children: categoryVM.categoryList.map((cat) {
                // Check selection state
                bool isSelected = productVM.selectedCategoryId.value == (cat.catId ?? 0).toString();

                return SizedBox(
                  width: chipWidth,
                  height: 40, // Symmetric Height
                  child: ChoiceChip(
                    showCheckmark: false,
                    selected: isSelected,

                    // --- IMPORTANT: Centering Fix ---
                    padding: EdgeInsets.zero,      // Internal padding zero
                    labelPadding: EdgeInsets.zero, // Label padding zero

                    label: Container(
                      width: chipWidth,
                      height: 40,
                      alignment: Alignment.center, // Horizontal and Vertical centering
                      child: Text(
                        cat.categoryName ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.0, // Ensures text doesn't drift vertically
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),

                    selectedColor: const Color(0xFF1A5ED3),
                    backgroundColor: Colors.grey.shade100,

                    // Border and Radius
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF1A5ED3) : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),

                    onSelected: (val) {
                      if (val) {
                        productVM.fetchProducts(
                            (cat.catId ?? 0).toString(),
                            categoryName: cat.categoryName ?? "All"
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}