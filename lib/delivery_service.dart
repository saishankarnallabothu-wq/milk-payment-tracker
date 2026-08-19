import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryService {

  static const String baseUrl =
      "http://127.0.0.1:8000";

  static Future<bool> addDelivery(
    int customerId,
    int delivered,
  ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/delivery"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "customer_id": customerId,
        "delivery_date":
            DateTime.now()
                .toString()
                .split(' ')[0],
        "delivered": delivered,
      }),
    );

    return response.statusCode == 200;
  }
}