import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ease/data/models/product_model.dart';
import 'package:shop_ease/data/repository/product_repository.dart';

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, AsyncValue<List<Product>>>(
      (ref) => ProductViewModel(ProductRepository()),
    );

class ProductViewModel extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductRepository _repository;

  ProductViewModel(this._repository) : super(const AsyncValue.loading()) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await _repository.fetchProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final flashSaleProvider = Provider<List<Product>>((ref) {
  final asyncProducts = ref.watch(productViewModelProvider);

  return asyncProducts.when(
    data: (products) {
      if (products.isEmpty) return [];

      final shuffled = List<Product>.from(products)..shuffle(Random());
      return shuffled.take(5).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
