import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryRepository {
  final String baseUrl = "https://fakestoreapi.com";

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse("$baseUrl/products/categories"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>(); // Convert to List<String>
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
