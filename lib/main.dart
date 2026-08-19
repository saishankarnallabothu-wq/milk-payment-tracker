import 'package:flutter/material.dart';

import 'api_service.dart';
import 'customers_screen.dart';
import 'deliveries_screen.dart';
import 'payments_screen.dart';
import 'bills_screen.dart';
import 'balance_screen.dart';
import 'monthly_report_screen.dart';
import 'delivery_history_screen.dart';

void main() {
  runApp(const MilkTrackerApp());
}

class MilkTrackerApp extends StatelessWidget {
  const MilkTrackerApp({super.key});

  static const Color brown = Color(0xFF754629);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Milk Tracker",
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F5F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: brown,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090909),
        colorScheme: ColorScheme.fromSeed(
          seedColor: brown,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color brown = Color(0xFF754629);
  static const Color darkBrown = Color(0xFF2C180D);
  static const Color mediumBrown = Color(0xFF4D2B18);

  int customers = 0;
  int deliveries = 0;
  double payments = 0;
  double balance = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final data = await ApiService.getDashboard();

    if (data != null && mounted) {
      setState(() {
        customers = int.tryParse(
              data["customers"].toString(),
            ) ??
            0;

        deliveries = int.tryParse(
              data["deliveries"].toString(),
            ) ??
            0;

        payments = double.tryParse(
              data["payments"].toString(),
            ) ??
            0;

        balance = double.tryParse(
              data["balance"].toString(),
            ) ??
            0;

        loading = false;
      });
    } else if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    ).then((_) {
      loadDashboard();
    });
  }

  void comingSoon(
    String title,
    IconData icon,
  ) {
    openScreen(
      ComingSoonScreen(
        title: title,
        icon: icon,
      ),
    );
  }

  Widget statItem({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F1ED),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: brown,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget quickButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              darkBrown,
              mediumBrown,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: brown.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 37,
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reportButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              darkBrown,
              mediumBrown,
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: brown.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 43,
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              backgroundColor: brown,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget toolButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              darkBrown,
              mediumBrown,
            ],
          ),
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: brown.withValues(alpha: 0.5),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showQuickAdd() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            5,
            20,
            30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Quick Add",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: brown,
                  child: Icon(
                    Icons.water_drop,
                    color: Colors.white,
                  ),
                ),
                title: const Text("Add Delivery"),
                onTap: () {
                  Navigator.pop(sheetContext);
                  openScreen(
                    const DeliveriesScreen(),
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: brown,
                  child: Icon(
                    Icons.currency_rupee,
                    color: Colors.white,
                  ),
                ),
                title: const Text("Add Payment"),
                onTap: () {
                  Navigator.pop(sheetContext);
                  openScreen(
                    const PaymentsScreen(),
                  );
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: brown,
                  child: Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                ),
                title: const Text("Add Customer"),
                onTap: () {
                  Navigator.pop(sheetContext);
                  openScreen(
                    const CustomersScreen(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadDashboard,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              110,
            ),
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_rounded,
                    size: 34,
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Text(
                      "Milk Tracker",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      comingSoon(
                        "Reminders",
                        Icons.notifications_rounded,
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Expanded(
                      flex: 35,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              darkBrown,
                              brown,
                            ],
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 43,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.local_drink,
                                color: brown,
                                size: 49,
                              ),
                            ),
                            SizedBox(height: 17),
                            Text(
                              "Track Milk",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Manage easily",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 65,
                      child: loading
                          ? const Center(
                              child:
                                  CircularProgressIndicator(),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      statItem(
                                        title: "Customers",
                                        value:
                                            customers.toString(),
                                        subtitle:
                                            "Total Customers",
                                        icon: Icons.people,
                                      ),
                                      statItem(
                                        title: "Today Delivery",
                                        value:
                                            deliveries.toString(),
                                        subtitle: "Delivered",
                                        icon:
                                            Icons.local_drink,
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: Row(
                                    children: [
                                      statItem(
                                        title: "Payment",
                                        value:
                                            "₹${payments.toStringAsFixed(0)}",
                                        subtitle: "Received",
                                        icon: Icons.wallet,
                                      ),
                                      statItem(
                                        title: "Balance",
                                        value:
                                            "₹${balance.toStringAsFixed(0)}",
                                        subtitle: "Total Due",
                                        icon:
                                            Icons.receipt_long,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.65,
                children: [
                  quickButton(
                    title: "Customers",
                    icon: Icons.person,
                    onTap: () => openScreen(
                      const CustomersScreen(),
                    ),
                  ),
                  quickButton(
                    title: "Add Delivery",
                    icon: Icons.water_drop,
                    onTap: () => openScreen(
                      const DeliveriesScreen(),
                    ),
                  ),
                  quickButton(
                    title: "Add Payment",
                    icon: Icons.currency_rupee,
                    onTap: () => openScreen(
                      const PaymentsScreen(),
                    ),
                  ),
                  quickButton(
                    title: "Bills",
                    icon: Icons.receipt_long,
                    onTap: () => openScreen(
                      const BillsScreen(),
                    ),
                  ),
                  quickButton(
                    title: "Balance",
                    icon: Icons.calculate,
                    onTap: () => openScreen(
                      const BalanceScreen(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "Reports",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: reportButton(
                      title: "Monthly Report",
                      subtitle: "View monthly summary",
                      icon: Icons.bar_chart,
                      onTap: () => openScreen(
                        const MonthlyReportScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: reportButton(
                      title: "Delivery History",
                      subtitle: "Track all deliveries",
                      icon: Icons.calendar_month,
                      onTap: () => openScreen(
                        const DeliveryHistoryScreen(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "More Tools",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.88,
                children: [
                  toolButton(
                    title: "Reminders",
                    icon: Icons.notifications,
                    onTap: () => comingSoon(
                      "Reminders",
                      Icons.notifications,
                    ),
                  ),
                  toolButton(
                    title: "Due Customers",
                    icon: Icons.manage_accounts_rounded,
                    onTap: () => comingSoon(
                      "Due Customers",
                      Icons.manage_accounts_rounded,
                    ),
                  ),
                  toolButton(
                    title: "Top Customers",
                    icon: Icons.groups,
                    onTap: () => comingSoon(
                      "Top Customers",
                      Icons.groups,
                    ),
                  ),
                  toolButton(
                    title: "Milk Rates",
                    icon: Icons.sell,
                    onTap: () => comingSoon(
                      "Milk Rates",
                      Icons.sell,
                    ),
                  ),
                  toolButton(
                    title: "Backup & Restore",
                    icon: Icons.cloud_sync,
                    onTap: () => comingSoon(
                      "Backup & Restore",
                      Icons.cloud_sync,
                    ),
                  ),
                  toolButton(
                    title: "Export Data",
                    icon: Icons.file_download,
                    onTap: () => comingSoon(
                      "Export Data",
                      Icons.file_download,
                    ),
                  ),
                  toolButton(
                    title: "Settings",
                    icon: Icons.settings,
                    onTap: () => comingSoon(
                      "Settings",
                      Icons.settings,
                    ),
                  ),
                  toolButton(
                    title: "Help & Support",
                    icon: Icons.headset_mic,
                    onTap: () => comingSoon(
                      "Help & Support",
                      Icons.headset_mic,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 31,
                      backgroundColor: brown,
                      child: Icon(
                        Icons.campaign,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Never miss a payment!",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Get reminders for due payments.",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        comingSoon(
                          "Reminders",
                          Icons.notifications,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brown,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Enable"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.large(
        backgroundColor: brown,
        foregroundColor: Colors.white,
        onPressed: showQuickAdd,
        child: const Icon(
          Icons.add,
          size: 39,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        height: 75,
        color: darkBrown,
        shape: const CircularNotchedRectangle(),
        notchMargin: 9,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            const BottomItem(
              icon: Icons.home,
              title: "Home",
            ),
            BottomItem(
              icon: Icons.person_outline,
              title: "Customers",
              onTap: () => openScreen(
                const CustomersScreen(),
              ),
            ),
            const SizedBox(width: 55),
            BottomItem(
              icon: Icons.bar_chart,
              title: "Reports",
              onTap: () => openScreen(
                const MonthlyReportScreen(),
              ),
            ),
            BottomItem(
              icon: Icons.grid_view,
              title: "More",
              onTap: () {
                comingSoon(
                  "More Tools",
                  Icons.grid_view,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const BottomItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const Color brown = Color(0xFF754629);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: brown,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Feature will be added next",
            ),
          ],
        ),
      ),
    );
  }
}