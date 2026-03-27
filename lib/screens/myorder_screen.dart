import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../AppManager/Models/AddtocartM/GetOrdersByFirm_model.dart';
import '../AppManager/ViewModel/AddtocartVM/GetOrderInvoice_vm.dart';
import '../AppManager/ViewModel/AddtocartVM/GetOrdersByFirm_vm.dart';
import '../Provider/order_provider.dart';
import '../widgets/date_filter_widget.dart';
import 'home_screen.dart';
import 'order_details_screen.dart';


class MyOrdersScreen extends StatefulWidget {
  final int firmId;
  const MyOrdersScreen({super.key, required this.firmId,});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final Color primaryColor = const Color(0xFF1A5ED3);

  final ordersVM = Get.put(GetOrdersByFirmVM(), permanent: true);
  final invoiceVM = Get.put(GetOrderInvoiceVM(), permanent: true);

  String _searchQuery = "";
  String _selectedFilter = "All";

  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();

    String from = "2026-01-01";
    String to = DateFormat("yyyy-MM-dd").format(DateTime.now());

    Future.delayed(const Duration(milliseconds: 500), () {
      ordersVM.fetchOrders(
        firmId: widget.firmId,
        fromDate: from,
        toDate: to,
      );
    });
  }

  void _goToHome() {
    Get.offAll(() => const HomeScreen());
  }

  Future<void> _handleDatePick(bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });

      if (_fromDate != null && _toDate != null) {
        ordersVM.fetchOrders(
          firmId: widget.firmId,
          fromDate: DateFormat("yyyy-MM-dd").format(_fromDate!),
          toDate: DateFormat("yyyy-MM-dd").format(_toDate!),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goToHome();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('My Orders', style: TextStyle(color: Colors.white)),
          backgroundColor: primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _goToHome(),
          ),
          actions: [
            if (_fromDate != null || _toDate != null)
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _fromDate = null;
                    _toDate = null;
                  });

                  String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
                  ordersVM.fetchOrders(
                    firmId: widget.firmId,
                    fromDate: "2026-01-01",
                    toDate: today,
                  );
                },
              )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            onChanged: (v) => setState(() => _searchQuery = v.trim()),
                            decoration: const InputDecoration(
                              hintText: "Search Order ID...",
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            items: [
                              "All",
                              "Placed",
                              "Live",
                              "Dispatched",
                              "Delivered",
                              "Return / Exchange"
                            ]
                                .map((val) => DropdownMenuItem(
                                value: val,
                                child: Text(val,
                                    style:
                                    const TextStyle(fontSize: 12))))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedFilter = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DateFilterWidget(
                    fromDate: _fromDate,
                    toDate: _toDate,
                    primaryColor: primaryColor,
                    onPickDate: _handleDatePick,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (ordersVM.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (ordersVM.orderList.isEmpty) {
                  return const Center(child: Text("No orders found"));
                }

                // Filtering logic
                final filteredOrders = ordersVM.orderList.where((order) {
                  final matchesSearch = order.orderId
                      .toString()
                      .contains(_searchQuery);

                  final matchesFilter = _selectedFilter == "All" ||
                      order.status == _selectedFilter;

                  bool matchesDate = true;
                  try {
                    DateTime orderDate = DateFormat("dd-MM-yyyy").parse(order.date);
                    if (_fromDate != null && orderDate.isBefore(_fromDate!)) {
                      matchesDate = false;
                    }
                    if (_toDate != null && orderDate.isAfter(_toDate!.add(const Duration(days: 1)))) {
                      matchesDate = false;
                    }
                  } catch (e) {
                    matchesDate = true;
                  }

                  return matchesSearch && matchesFilter && matchesDate;
                }).toList();

                if (filteredOrders.isEmpty) {
                  return const Center(child: Text("No matching orders found"));
                }


                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(filteredOrders[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderData order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          int orderId = order.orderId;
          await invoiceVM.fetchInvoice(orderId);
          final orderProvider = Provider.of<OrderProvider>(context, listen: false);
          await orderProvider.getOrderDetails(orderId);
          Get.to(() => OrderDetailsScreen(orderId: order.orderId.toString()));
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.shopping_bag_outlined, color: primaryColor),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order #${order.orderId}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        _statusBadge(order.status),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text("₹${order.totalAmount}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(order.date,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(6)),
      child: Text(status,
          style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}