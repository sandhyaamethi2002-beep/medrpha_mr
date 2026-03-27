import 'package:flutter/material.dart';
import '../AppManager/Models/CategoryM/getByCategoryId_model.dart';

class ProductCard2 extends StatelessWidget {
  final ProductData product;

  const ProductCard2({
    super.key,
    required this.product, required int firmId, required int userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE SECTION
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://mrnew.medrpha.com/uploads/${product.productImg}",
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(
                  Icons.image_not_supported,
                  size: 30,
                  color: Colors.black26,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// DETAILS SECTION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (product.productName ?? "N/A").toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description ?? "N/A",
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "By ${product.companyName ?? "Unknown"}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}