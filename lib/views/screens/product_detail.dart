import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../widgets/cart_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.image,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/icons/placeholder.png",
                    height: 250,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              "₹ ${(product.price * 90).toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text("${product.rating} (${product.ratingCount} reviews)"),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 10),
            CartButton(product: product),
          ],
        ),
      ),
    );
  }
}
