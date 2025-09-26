import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "https://fakestoreapi.com";

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse("$baseUrl/$endpoint"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }
}
