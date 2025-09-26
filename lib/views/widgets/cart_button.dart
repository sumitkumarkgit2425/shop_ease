import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../../viewmodels/cart_viewmodel.dart';
import 'package:flutter/material.dart';

class CartButton extends ConsumerWidget {
  final Product product;
  const CartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size(360, 50), // width, height
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            onPressed: () {
              ref.read(cartProvider.notifier).addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${product.title} added to cart")),
              );
            },
            child: const Text(
              "Add to Cart",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
