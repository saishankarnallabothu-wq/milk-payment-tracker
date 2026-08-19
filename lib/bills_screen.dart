import 'package:flutter/material.dart';
import 'api_service.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() =>
      _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {

  List customers = [];
  Map<String, dynamic>? billData;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    customers = await ApiService.getCustomers();
    setState(() {});
  }

  Future<void> loadBill(int customerId) async {
    billData =
        await ApiService.getBill(customerId);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bills"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {

                  return Card(
                    child: ListTile(
                      title: Text(
                        customers[index][1],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          loadBill(
                            customers[index][0],
                          );
                        },
                        child: const Text(
                          "View Bill",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (billData != null)
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      Text(
                        "Customer: ${billData!['customer_name']}",
                      ),

                      Text(
                        "Days Taken: ${billData!['days_taken']}",
                      ),

                      Text(
                        "Milk/Day: ${billData!['milk_per_day']}",
                      ),

                      Text(
                        "Rate: ₹${billData!['rate']}",
                      ),

                      Text(
                        "Total Bill: ₹${billData!['total_bill']}",
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}