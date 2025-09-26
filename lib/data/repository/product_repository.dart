import 'package:shop_ease/data/network/api_client.dart';

import '../models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> fetchProducts() async {
    final data = await _apiClient.get("products");
    return (data as List).map((json) => Product.fromJson(json)).toList();
  }
}
