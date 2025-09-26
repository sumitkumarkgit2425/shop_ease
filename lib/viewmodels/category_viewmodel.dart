import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ease/data/repository/category_repository.dart';

final categoryViewModelProvider =
    StateNotifierProvider<CategoryViewModel, AsyncValue<List<String>>>(
      (ref) => CategoryViewModel(CategoryRepository()),
    );

class CategoryViewModel extends StateNotifier<AsyncValue<List<String>>> {
  final CategoryRepository _repository;

  CategoryViewModel(this._repository) : super(const AsyncValue.loading()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await _repository.fetchCategories();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
