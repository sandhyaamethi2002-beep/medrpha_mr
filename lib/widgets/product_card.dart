import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cart_provider.dart';
import '../controllers/product_controller.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final quantity = cart.getProductQuantity(product.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6), // Vertical margin kam kiya
      padding: const EdgeInsets.all(14), // Padding thoda kam kiya card chhota karne ke liye
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2)
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE SECTION
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.image,
              height: 80, // Image size wapas 80 kar diya
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 80, width: 80, color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 25),
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
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Font size slightly adjusted
                ),
                const SizedBox(height: 4),
                Text(
                  product.subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  "By ${product.company}",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),

          /// ACTION SECTION
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.bookmark_border, color: Colors.grey, size: 20),
              const SizedBox(height: 25), // Space kam kiya chote card ke liye

              quantity == 0
                  ? SizedBox(
                height: 38, // Height halki si kam ki
                width: 95,  // Width halki si kam ki
                child: ElevatedButton(
                  onPressed: () => cart.addToCart(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5ED3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 18, color: Colors.white),
                      Text(" Add", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
                  : Container(
                height: 38,
                width: 95,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1A5ED3), width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => cart.removeFromCart(product.id),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.remove, size: 18, color: Color(0xFF1A5ED3)),
                      ),
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A5ED3)),
                    ),
                    InkWell(
                      onTap: () => cart.addToCart(product),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.add, size: 18, color: Color(0xFF1A5ED3)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}