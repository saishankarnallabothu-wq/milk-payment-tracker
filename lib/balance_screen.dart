import 'package:flutter/material.dart';
import 'api_service.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() =>
      _BalanceScreenState();
}

class _BalanceScreenState
    extends State<BalanceScreen> {

  List customers = [];
  Map<String, dynamic>? balanceData;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    customers =
        await ApiService.getCustomers();

    setState(() {});
  }

  Future<void> loadBalance(
      int customerId) async {

    balanceData =
        await ApiService.getBalance(
            customerId);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Balance"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Expanded(
              child: ListView.builder(
                itemCount: customers.length,

                itemBuilder:
                    (context, index) {

                  return Card(
                    child: ListTile(
                      title: Text(
                        customers[index][1]
                            .toString(),
                      ),

                      trailing:
                          ElevatedButton(
                        onPressed: () {

                          loadBalance(
                            customers[index]
                                [0],
                          );
                        },

                        child:
                            const Text(
                          "View",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (balanceData != null)
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                          16),

                  child: Column(
                    children: [

                      Text(
                        "Customer: ${balanceData!['customer_name']}",
                      ),

                      Text(
                        "Total Bill: ₹${balanceData!['total_bill']}",
                      ),

                      Text(
                        "Paid: ₹${balanceData!['paid_amount']}",
                      ),

                      Text(
                        "Balance: ₹${balanceData!['balance_amount']}",
                        style:
                            const TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
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