import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../AppManager/ViewModel/CategoryVM/getProductDetail_vm.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel ko find kiya
    final ProductDetailsViewModel vm = Get.find<ProductDetailsViewModel>();

    // Screen width ke hisab se width calculate ki taaki 3 chips line me aaye
    double chipWidth = (MediaQuery.of(context).size.width - 60) / 3;

    final List<String> categories = [
      "All",  "Ethical",
      "General", "Generic", "Surgical","Ayurvedic", "Veterinary"
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top handle bar
          Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
              )
          ),

          const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Select Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              )
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: categories.map((cat) {
              return Obx(() {
                bool isSelected = vm.selectedCategory.value == cat;
                return SizedBox(
                  width: chipWidth,
                  height: 45, // Height thodi badhai taaki text center me space dikhe
                  child: ChoiceChip(
                    showCheckmark: false,
                    selected: isSelected,
                    // Padding zero ki taaki container pura area le sake
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    label: Container(
                      width: chipWidth,
                      height: 45,
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87
                        ),
                      ),
                    ),
                    selectedColor: const Color(0xFF1A5ED3),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF1A5ED3) : Colors.grey.shade300,
                      ),
                    ),
                    onSelected: (val) {
                      if (val) {
                        vm.filterByCategory(cat);
                        Get.back(); // Bottom sheet close karne ke liye
                      }
                    },
                  ),
                );
              });
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}