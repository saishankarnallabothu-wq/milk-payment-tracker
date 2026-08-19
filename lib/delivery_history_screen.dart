import 'package:flutter/material.dart';
import 'api_service.dart';

class DeliveryHistoryScreen
    extends StatefulWidget {

  const DeliveryHistoryScreen(
      {super.key});

  @override
  State<DeliveryHistoryScreen>
      createState() =>
          _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState
    extends State<
        DeliveryHistoryScreen> {

  List history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {

    history =
        await ApiService
            .getDeliveryHistory();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delivery History",
        ),
      ),

      body: ListView.builder(
        itemCount: history.length,

        itemBuilder:
            (context, index) {

          return Card(
            child: ListTile(
              title: Text(
                history[index][1]
                    .toString(),
              ),

              subtitle: Text(
                history[index][0]
                    .toString(),
              ),

              trailing: Text(
                history[index][2] == 1
                    ? "✅"
                    : "❌",
                style:
                    const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}