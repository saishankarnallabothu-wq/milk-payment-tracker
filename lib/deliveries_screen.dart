import 'package:flutter/material.dart';
import 'api_service.dart';
import 'delivery_service.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() =>
      _DeliveriesScreenState();
}

class _DeliveriesScreenState
    extends State<DeliveriesScreen> {

  List customers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {

    final data =
        await ApiService.getCustomers();

    setState(() {
      customers = data;
      isLoading = false;
    });
  }

  Future<void> markDelivery(
    int customerId,
    int delivered,
  ) async {

    bool success =
        await DeliveryService.addDelivery(
      customerId,
      delivered,
    );

    if (success) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            delivered == 1
                ? "Delivery Saved"
                : "Marked Not Delivered",
          ),
        ),
      );
    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text("Failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final today = DateTime.now();

    final dayName = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][today.weekday - 1];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Deliveries"),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Column(
              children: [

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(
                          12),
                  color:
                      Colors.blue.shade50,

                  child: Column(
                    children: [

                      Text(
                        "Date: ${today.toString().split(' ')[0]}",
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 5),

                      Text(
                        "Day: $dayName",
                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child:
                      ListView.builder(
                    itemCount:
                        customers.length,

                    itemBuilder:
                        (context,
                            index) {

                      return Card(
                        margin:
                            const EdgeInsets
                                .all(8),

                        child:
                            ListTile(
                          title: Text(
                            customers[index]
                                    [1]
                                .toString(),
                          ),

                          subtitle: Text(
                            "${customers[index][3]} Litre",
                          ),

                          trailing:
                              Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min,

                            children: [

                              ElevatedButton(
                                onPressed:
                                    () {

                                  markDelivery(
                                    customers[index]
                                        [0],
                                    1,
                                  );
                                },

                                child:
                                    const Text(
                                  "✔",
                                ),
                              ),

                              const SizedBox(
                                  width: 8),

                              ElevatedButton(
                                onPressed:
                                    () {

                                  markDelivery(
                                    customers[index]
                                        [0],
                                    0,
                                  );
                                },

                                child:
                                    const Text(
                                  "❌",
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
    );
  }
}