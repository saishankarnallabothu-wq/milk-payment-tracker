import 'package:flutter/material.dart';
import 'api_service.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() =>
      _CustomersScreenState();
}

class _CustomersScreenState
    extends State<CustomersScreen> {

  List customers = [];
  List filteredCustomers = [];

  bool isLoading = true;

  final searchController =
      TextEditingController();

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final milkController =
      TextEditingController();

  final rateController =
      TextEditingController();

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
      filteredCustomers = data;
      isLoading = false;
    });
  }

  void searchCustomer(String value) {

    setState(() {

      filteredCustomers =
          customers.where((customer) {

        return customer[1]
            .toString()
            .toLowerCase()
            .contains(
              value.toLowerCase(),
            );

      }).toList();
    });
  }

  Future<void> addCustomer() async {

    bool success =
        await ApiService.addCustomer(
      nameController.text,
      phoneController.text,
      double.parse(
        milkController.text,
      ),
      double.parse(
        rateController.text,
      ),
    );

    if (success) {

      Navigator.pop(context);

      nameController.clear();
      phoneController.clear();
      milkController.clear();
      rateController.clear();

      loadCustomers();
    }
  }

  Future<void> deleteCustomer(
      int customerId) async {

    bool success =
        await ApiService.deleteCustomer(
            customerId);

    if (success) {

      loadCustomers();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Customer Deleted"),
        ),
      );
    }
  }

  void showAddCustomerDialog() {

    showDialog(
      context: context,

      builder: (_) => AlertDialog(
        title:
            const Text("Add Customer"),

        content:
            SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText: "Name",
                ),
              ),

              TextField(
                controller:
                    phoneController,
                decoration:
                    const InputDecoration(
                  labelText: "Phone",
                ),
              ),

              TextField(
                controller:
                    milkController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Milk Qty",
                ),
              ),

              TextField(
                controller:
                    rateController,
                decoration:
                    const InputDecoration(
                  labelText: "Rate",
                ),
              ),
            ],
          ),
        ),

        actions: [

          ElevatedButton(
            onPressed: addCustomer,
            child:
                const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Customers"),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed:
            showAddCustomerDialog,
        child:
            const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Column(
              children: [

                Padding(
                  padding:
                      const EdgeInsets.all(
                          8),
                  child: TextField(
                    controller:
                        searchController,

                    decoration:
                        const InputDecoration(
                      labelText:
                          "Search Customer",
                      prefixIcon:
                          Icon(Icons.search),
                      border:
                          OutlineInputBorder(),
                    ),

                    onChanged:
                        searchCustomer,
                  ),
                ),

                Expanded(
                  child:
                      ListView.builder(
                    itemCount:
                        filteredCustomers
                            .length,

                    itemBuilder:
                        (context,
                            index) {

                      return Card(
                        margin:
                            const EdgeInsets
                                .all(8),

                        child:
                            ListTile(

                          leading:
                              CircleAvatar(
                            child: Text(
                              filteredCustomers[
                                      index]
                                  [0]
                                  .toString(),
                            ),
                          ),

                          title: Text(
                            filteredCustomers[
                                    index]
                                [1]
                                .toString(),
                          ),

                          subtitle:
                              Text(
                            "Phone: ${filteredCustomers[index][2]}"
                            "\nMilk Qty: ${filteredCustomers[index][3]} L"
                            "\nRate: ₹${filteredCustomers[index][4]}",
                          ),

                          trailing:
                              Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min,

                            children: [
IconButton(
  icon: const Icon(
    Icons.edit,
    color: Colors.blue,
  ),
  onPressed: () {

    nameController.text =
        filteredCustomers[index][1].toString();

    phoneController.text =
        filteredCustomers[index][2].toString();

    milkController.text =
        filteredCustomers[index][3].toString();

    rateController.text =
        filteredCustomers[index][4].toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Customer"),

        content: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                ),
              ),

              TextField(
                controller: milkController,
                decoration: const InputDecoration(
                  labelText: "Milk Qty",
                ),
              ),

              TextField(
                controller: rateController,
                decoration: const InputDecoration(
                  labelText: "Rate",
                ),
              ),
            ],
          ),
        ),

        actions: [

          ElevatedButton(
            onPressed: () async {

              bool success =
                  await ApiService.updateCustomer(
                filteredCustomers[index][0],
                nameController.text,
                phoneController.text,
                double.parse(
                    milkController.text),
                double.parse(
                    rateController.text),
              );

              if (success) {

                Navigator.pop(context);

                loadCustomers();

                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Customer Updated",
                    ),
                  ),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  },
),
                              IconButton(
                                icon:
                                    const Icon(
                                  Icons
                                      .delete,
                                  color:
                                      Colors.red,
                                ),

                                onPressed:
                                    () {

                                  deleteCustomer(
                                    filteredCustomers[
                                            index]
                                        [0],
                                  );
                                },
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