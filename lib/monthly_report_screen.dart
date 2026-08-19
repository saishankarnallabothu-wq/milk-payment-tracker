import 'package:flutter/material.dart';
import 'api_service.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  State<MonthlyReportScreen> createState() =>
      _MonthlyReportScreenState();
}

class _MonthlyReportScreenState
    extends State<MonthlyReportScreen> {

  List report = [];

  bool isLoading = true;

  String selectedMonth = "June 2026";

  final months = [
    "January 2026",
    "February 2026",
    "March 2026",
    "April 2026",
    "May 2026",
    "June 2026",
    "July 2026",
    "August 2026",
    "September 2026",
    "October 2026",
    "November 2026",
    "December 2026",
  ];

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  Future<void> loadReport() async {

   String monthNumber = "06";

if (selectedMonth.startsWith("January")) {
  monthNumber = "01";
}
else if (selectedMonth.startsWith("February")) {
  monthNumber = "02";
}
else if (selectedMonth.startsWith("March")) {
  monthNumber = "03";
}
else if (selectedMonth.startsWith("April")) {
  monthNumber = "04";
}
else if (selectedMonth.startsWith("May")) {
  monthNumber = "05";
}
else if (selectedMonth.startsWith("June")) {
  monthNumber = "06";
}
else if (selectedMonth.startsWith("July")) {
  monthNumber = "07";
}
else if (selectedMonth.startsWith("August")) {
  monthNumber = "08";
}
else if (selectedMonth.startsWith("September")) {
  monthNumber = "09";
}
else if (selectedMonth.startsWith("October")) {
  monthNumber = "10";
}
else if (selectedMonth.startsWith("November")) {
  monthNumber = "11";
}
else if (selectedMonth.startsWith("December")) {
  monthNumber = "12";
}

report =
    await ApiService.getMonthlyReport(
        monthNumber);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Monthly Report"),
      ),

      body: Column(
        children: [

          Padding(
            padding:
                const EdgeInsets.all(10),

            child: DropdownButtonFormField(
              value: selectedMonth,

              decoration:
                  const InputDecoration(
                labelText:
                    "Select Month",
                border:
                    OutlineInputBorder(),
              ),

              items: months.map((month) {

                return DropdownMenuItem(
                  value: month,
                  child: Text(month),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedMonth =
                      value.toString();
                });

                loadReport();
              },
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount:
                        report.length,

                    itemBuilder:
                        (context, index) {

                      return Card(
                        margin:
                            const EdgeInsets
                                .all(8),

                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .all(12),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                report[index]
                                        ["name"]
                                    .toString(),

                                style:
                                    const TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                "Bill: ₹${report[index]["bill"]}",
                              ),

                              Text(
                                "Paid: ₹${report[index]["paid"]}",
                              ),

                              Text(
                                "Balance: ₹${report[index]["balance"]}",
                              ),

                              Text(
                                "Payment Date: ${report[index]["payment_date"]}",
                              ),

                              Text(
                                "Month: $selectedMonth",
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