import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/AddtocartVM/DeleteCartById_vm.dart';
import '../Provider/cart_provider.dart';
import '../widgets/bill_summary_widget.dart';

class CartScreen extends StatefulWidget {
  final String firmName;
  final int firmId;
  final int userId;
  final int roleId;
  final int userTypeId;
  final String? address;
  final String? phoneno;

  const CartScreen({
    super.key,
    required this.firmId,
    required this.userId,
    required this.roleId,
    required this.userTypeId,
    required this.firmName,
    this.address,
    this.phoneno,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  Future<void> _initData() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    await cartProvider.loadCart(
      firmId: widget.firmId,
      userTypeId: widget.userTypeId,
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCart() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.loadCart(
      firmId: widget.firmId,
      userTypeId: widget.userTypeId,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("CartScreen Data: ${widget.firmName}, ${widget.phoneno}");
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],

      /// APPBAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5ED3),
        elevation: 0,
        title: const Text(
          "MY CART",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isLoading && cartProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              tooltip: "Clear All Items",
              onPressed: () => _showClearCartDialog(cartProvider),
            ),
        ],
      ),

      /// BODY (Product List)
      body: _isLoading || cartProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A5ED3)))
          : Consumer<CartProvider>(
        builder: (context, provider, _) {
          final cartList = provider.items.values.toList();

          if (cartList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text(
                    "Your cart is empty",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: cartList.length,
            padding: const EdgeInsets.only(top: 10, bottom: 150),
            itemBuilder: (context, index) {
              final item = cartList[index];
              final product = item.product;
              int currentQty = item.quantity;

              // 2. Identify the correct step (min_quantity)
              int step = int.tryParse(product.minQty?.toString() ?? "1") ?? 1;

              // 3. Dynamic Price Calculations (Unit Price * Quantity)
              double unitPrice = double.tryParse(product.finalCompanyPrice.toString()) ?? 0.0;
              double unitMrp = (product.mrp != null && product.mrp! > 0)
                  ? product.mrp!
                  : unitPrice;

              double totalItemPrice = unitPrice * currentQty;
              double totalItemMrp = unitMrp * currentQty;

              String imageUrl = product.productImg ?? "noimage.png";
              if (!imageUrl.startsWith('http')) {
                imageUrl = "https://mrnew.medrpha.com/uploads/$imageUrl";
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    /// PRODUCT IMAGE
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(
                              Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    /// PRODUCT DETAILS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName ?? "N/A",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            product.companyName ?? "Unknown Company",
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                          const SizedBox(height: 8),

                          // MRP SECTION (Bug Fixed: Now showing Total MRP for this qty)
                          // if (totalItemMrp > totalItemPrice)
                            Text(
                              "₹ ${totalItemMrp.toStringAsFixed(2)}",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),

                          const SizedBox(height: 2),

                          // FINAL PRICE SECTION (Bug Fixed: Now showing Total Price for this qty)
                          Row(
                            children: [
                              Text(
                                "₹ ${totalItemPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Color(0xFF1A5ED3),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// REMOVE ICON & QUANTITY CONTROLLER
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => _showRemoveSingleItemDialog(provider, item.cartId),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 8.0, right: 4.0),
                            child: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                          ),
                        ),

                        // Quantity Selector
                        Container(
                          height: 38,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF1A5ED3), width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// MINUS BUTTON
                              InkWell(
                                onTap: () {
                                  // Logic: Sends step to provider. If current is 10 and step is 10,
                                  // nextQty becomes 0 and removeFromCartCompletely is triggered.
                                  provider.removeFromCart(
                                    product.pid.toString(),
                                    firmId: widget.firmId,
                                    userId: widget.userId,
                                    minQty: step, // Explicitly pass the correct step
                                  );
                                },
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.remove, size: 18, color: Color(0xFF1A5ED3))),
                              ),

                              // Current Quantity Display
                              Text("$currentQty",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1A5ED3))),

                              /// PLUS BUTTON
                              InkWell(
                                onTap: () => provider.addToCart(
                                  product: product,
                                  firmId: widget.firmId,
                                  userId: widget.userId,
                                  minQty: step, // Explicitly pass the correct step
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.add, size: 18, color: Color(0xFF1A5ED3))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      /// BOTTOM BILL SUMMARY
      bottomNavigationBar: cartProvider.items.isEmpty
          ? const SizedBox.shrink()
          : BillSummaryWidget(
        firmId: widget.firmId,
        address: widget.address,
        userId: widget.userId,
        phoneno: widget.phoneno,
        firmName: widget.firmName, roleId: widget.roleId, userTypeId: widget.userTypeId,
      ),
    );
  }

  Future<void> _handleDeleteItem(int cartId) async {
    print(" Cart ID: $cartId");
    print(" UserTypeId: ${widget.userTypeId}");

    setState(() { _isLoading = true; });

    try {
      final vm = Provider.of<DeleteCartByIdVM>(context, listen: false);

      // Sahi API call
      final response = await vm.deleteCart(
        cartId: cartId,
        userTypeId: widget.userTypeId,
      );

      if (response != null && response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.message ?? "Item Deleted"),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1)
            ),
          );
          await _loadCart();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response?.message ?? "Delete Failed"),
                backgroundColor: Colors.red
            ),
          );
        }
      }
    } catch (e) {
      print("Error deleting item: $e");
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  void _showRemoveSingleItemDialog(CartProvider provider, int cartId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Delete Item?"),
        content: const Text("Are you sure you want to remove this item from cart?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("No")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleDeleteItem(cartId);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  void _showClearCartDialog(CartProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear Cart?"),
        content: const Text("Are you want to clear cart items?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("No")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.clearCartFromServer(firmId: widget.firmId, userId: widget.userId);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}