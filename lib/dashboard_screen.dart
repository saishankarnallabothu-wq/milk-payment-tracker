import 'package:flutter/material.dart';
import 'api_service.dart';

import 'customers_screen.dart';
import 'deliveries_screen.dart';
import 'payments_screen.dart';
import 'bills_screen.dart';
import 'balance_screen.dart';
import 'monthly_report_screen.dart';
import 'delivery_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final result =
        await ApiService.getDashboard();

    setState(() {
      data = result;
    });
  }

  Widget statCard(
    String title,
    String value,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildModuleCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        ).then((_) {
          loadDashboard();
        });
      },
      child: Card(
        elevation: 4,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (data == null) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Milk Tracker Dashboard",
        ),
        actions: [
          IconButton(
            onPressed: loadDashboard,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(12),

        child: Column(
          children: [

            Row(
              children: [

                statCard(
                  "Customers",
                  data!["customers"]
                      .toString(),
                ),

                const SizedBox(width: 10),

                statCard(
                  "Deliveries",
                  data!["deliveries"]
                      .toString(),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                statCard(
                  "Payments",
                  "₹${data!["payments"]}",
                ),

                const SizedBox(width: 10),

                statCard(
                  "Balance",
                  "₹${data!["balance"]}",
                ),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,

                children: [

                  buildModuleCard(
                    context,
                    "Customers",
                    Icons.people,
                    const CustomersScreen(),
                  ),

                  buildModuleCard(
                    context,
                    "Deliveries",
                    Icons.local_drink,
                    const DeliveriesScreen(),
                  ),

                  buildModuleCard(
                    context,
                    "Payments",
                    Icons.payments,
                    const PaymentsScreen(),
                  ),

                  buildModuleCard(
                    context,
                    "Bills",
                    Icons.receipt_long,
                    const BillsScreen(),
                  ),

                  buildModuleCard(
                    context,
                    "Balance",
                    Icons.account_balance_wallet,
                    const BalanceScreen(),
                  ),

                  buildModuleCard(
                    context,
                    "Monthly Report",
                    Icons.bar_chart,
                    const MonthlyReportScreen(),
                  ),

                  buildModuleCard(
                    context,
                    "Delivery History",
                    Icons.history,
                    const DeliveryHistoryScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}