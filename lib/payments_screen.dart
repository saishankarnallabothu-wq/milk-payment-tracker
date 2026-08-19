import 'package:flutter/material.dart';
import 'api_service.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  List<dynamic> customers = [];
  List<dynamic> payments = [];

  final Map<int, TextEditingController> controllers = {};

  bool isLoading = true;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    customers = await ApiService.getCustomers();
    payments = await ApiService.getPaymentHistory();

    for (var customer in customers) {
      final int customerId = customer[0];

      controllers.putIfAbsent(
        customerId,
        () => TextEditingController(),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addPayment(int customerId) async {
    final controller = controllers[customerId];

    if (controller == null || controller.text.trim().isEmpty) {
      showMessage("Enter Amount");
      return;
    }

    final double? amount = double.tryParse(
      controller.text.trim(),
    );

    if (amount == null || amount <= 0) {
      showMessage("Enter Valid Amount");
      return;
    }

    final bool success = await ApiService.addPayment(
      customerId,
      amount,
    );

    if (success) {
      controller.clear();

      showMessage("Payment Saved");

      await loadData();
    } else {
      showMessage("Payment Failed");
    }
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String monthName(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);

      const months = [
        "JANUARY",
        "FEBRUARY",
        "MARCH",
        "APRIL",
        "MAY",
        "JUNE",
        "JULY",
        "AUGUST",
        "SEPTEMBER",
        "OCTOBER",
        "NOVEMBER",
        "DECEMBER",
      ];

      return "${months[parsedDate.month - 1]} ${parsedDate.year}";
    } catch (_) {
      return "PAYMENTS";
    }
  }

  String formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateTime today = DateTime.now();

      final DateTime currentDate = DateTime(
        today.year,
        today.month,
        today.day,
      );

      final DateTime paymentDate = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
      );

      final int difference = currentDate
          .difference(paymentDate)
          .inDays;

      if (difference == 0) {
        return "Today";
      }

      if (difference == 1) {
        return "1 day ago";
      }

      if (difference > 1 && difference < 30) {
        return "$difference days ago";
      }

      return "${parsedDate.day.toString().padLeft(2, '0')}/"
          "${parsedDate.month.toString().padLeft(2, '0')}/"
          "${parsedDate.year}";
    } catch (_) {
      return date;
    }
  }

  Map<String, List<dynamic>> groupPayments() {
    final Map<String, List<dynamic>> grouped = {};

    final filteredPayments = payments.where((payment) {
      final String customerName =
          payment["customer_name"].toString().toLowerCase();

      return customerName.contains(
        searchText.toLowerCase(),
      );
    }).toList();

    for (var payment in filteredPayments) {
      final String month = monthName(
        payment["payment_date"].toString(),
      );

      grouped.putIfAbsent(month, () => []);

      grouped[month]!.add(payment);
    }

    return grouped;
  }

  double monthTotal(List<dynamic> monthPayments) {
    double total = 0;

    for (var payment in monthPayments) {
      total += double.tryParse(
            payment["amount"].toString(),
          ) ??
          0;
    }

    return total;
  }

  void showAddPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B1B1B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      final int customerId = customer[0];

                      return Card(
                        color: const Color(0xFF292929),
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer[1].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller:
                                    controllers[customerId],
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter Amount",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  prefixText: "₹ ",
                                  prefixStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor:
                                      const Color(0xFF181818),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await addPayment(customerId);

                                    if (mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Save Payment"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedPayments = groupPayments();

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Payment History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddPaymentSheet,
        icon: const Icon(Icons.add),
        label: const Text("Add Payment"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search payments",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF252525),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (groupedPayments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: Text(
                          "No Payment History",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ...groupedPayments.entries.map(
                    (entry) {
                      final String month = entry.key;
                      final List<dynamic> monthPayments =
                          entry.value;

                      final double total = monthTotal(
                        monthPayments,
                      );

                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  month,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "+ ₹${total.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Color(0xFF2ED573),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1D1D1D),
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: monthPayments.map(
                                (payment) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        leading: Container(
                                          width: 48,
                                          height: 48,
                                          decoration:
                                              const BoxDecoration(
                                            color: Color(0xFF294C3A),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.south_west,
                                            color:
                                                Color(0xFF2ED573),
                                          ),
                                        ),
                                        title: const Text(
                                          "Received from",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 3),
                                            Text(
                                              payment["customer_name"]
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight:
                                                    FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              formatDate(
                                                payment["payment_date"]
                                                    .toString(),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          "+ ₹${double.parse(payment["amount"].toString()).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color:
                                                Color(0xFF2ED573),
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (payment !=
                                          monthPayments.last)
                                        const Divider(
                                          color: Color(0xFF333333),
                                          height: 1,
                                          indent: 80,
                                        ),
                                    ],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}