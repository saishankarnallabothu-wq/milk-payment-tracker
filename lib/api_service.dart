import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";

  // =========================
  // GET CUSTOMERS
  // =========================

  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/customers"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["customers"];
      }
    } catch (e) {
      print("Get Customers Error: $e");
    }

    return [];
  }

  // =========================
  // ADD CUSTOMER
  // =========================

  static Future<bool> addCustomer(
    String name,
    String phone,
    double milkQty,
    double rate,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/customer"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "milk_qty": milkQty,
          "rate": rate,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Add Customer Error: $e");
      return false;
    }
  }

  // =========================
  // ADD DELIVERY
  // =========================

  static Future<bool> addDelivery(
    int customerId,
    int delivered, [
    double? qty,
  ]) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delivery"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "customer_id": customerId,
          "delivery_date":
              DateTime.now().toString().split(' ')[0],
          "delivered": delivered,
          "qty": delivered == 1 ? (qty ?? 0) : 0,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Add Delivery Error: $e");
      return false;
    }
  }

  // =========================
  // GET BILL
  // =========================

  static Future<Map<String, dynamic>?> getBill(
    int customerId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/bill/$customerId"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Get Bill Error: $e");
    }

    return null;
  }

  // =========================
  // ADD PAYMENT
  // =========================

  static Future<bool> addPayment(
    int customerId,
    double amount,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/payment"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "customer_id": customerId,
          "amount": amount,
          "payment_date":
              DateTime.now().toString().split(' ')[0],
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Add Payment Error: $e");
      return false;
    }
  }

  // =========================
  // PAYMENT HISTORY
  // =========================

  static Future<List<dynamic>> getPaymentHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/payment-history"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["history"];
      }
    } catch (e) {
      print("Payment History Error: $e");
    }

    return [];
  }

  // =========================
  // GET BALANCE
  // =========================

  static Future<Map<String, dynamic>?> getBalance(
    int customerId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/balance/$customerId"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Get Balance Error: $e");
    }

    return null;
  }

  // =========================
  // GET DASHBOARD
  // =========================

  static Future<Map<String, dynamic>?> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/dashboard"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Dashboard Error: $e");
    }

    return null;
  }

  // =========================
  // DELETE CUSTOMER
  // =========================

  static Future<bool> deleteCustomer(
    int customerId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/customer/$customerId"),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Delete Customer Error: $e");
      return false;
    }
  }

  // =========================
  // UPDATE CUSTOMER
  // =========================

  static Future<bool> updateCustomer(
    int customerId,
    String name,
    String phone,
    double milkQty,
    double rate,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/customer/$customerId"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "milk_qty": milkQty,
          "rate": rate,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Update Customer Error: $e");
      return false;
    }
  }

  // =========================
  // MONTHLY REPORT
  // =========================

  static Future<List<dynamic>> getMonthlyReport(
    String month,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          "$baseUrl/monthly-report?month=$month",
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Monthly Report Error: $e");
    }

    return [];
  }

  // =========================
  // DELIVERY HISTORY
  // =========================

  static Future<List<dynamic>> getDeliveryHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/delivery-history"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)["history"];
      }
    } catch (e) {
      print("Delivery History Error: $e");
    }

    return [];
  }
}