import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/Cart.dart';
import '../data/models/product_model.dart';

class CartState {
  final Map<int, CartItem> items;

  CartState({required this.items});

  factory CartState.initial() => CartState(items: {});

  bool get isEmpty => items.isEmpty;

  Iterable<MapEntry<int, CartItem>> get entries => items.entries;

  double get totalUsd =>
      items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState.initial());

  void addItem(Product product) {
    final currentItems = Map<int, CartItem>.from(state.items);

    if (currentItems.containsKey(product.id)) {
      final existing = currentItems[product.id]!;
      currentItems[product.id] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
    } else {
      currentItems[product.id] = CartItem(product: product, quantity: 1);
    }

    state = CartState(items: currentItems);
  }

  void decreaseItem(int productId) {
    final currentItems = Map<int, CartItem>.from(state.items);

    if (!currentItems.containsKey(productId)) return;

    final existing = currentItems[productId]!;
    if (existing.quantity > 1) {
      currentItems[productId] = existing.copyWith(
        quantity: existing.quantity - 1,
      );
    } else {
      currentItems.remove(productId);
    }

    state = CartState(items: currentItems);
  }

  void removeItem(int productId) {
    final currentItems = Map<int, CartItem>.from(state.items);
    currentItems.remove(productId);
    state = CartState(items: currentItems);
  }

  void clearCart() {
    state = CartState(items: {});
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(),
);

final cartTotalUsdProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalUsd;
});
