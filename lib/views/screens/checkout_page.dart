import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shop_ease/viewmodels/cart_viewmodel.dart';
import 'package:shop_ease/views/screens/payment_page.dart';

import '../../constant/app_color.dart';

final addressProvider = StateProvider<String>((ref) {
  return "John Doe\n123 Main Street\nNew Delhi, 110001";
});

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final totalUsd = ref.watch(cartTotalUsdProvider);
    final address = ref.watch(addressProvider);

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    final totalInr = totalUsd * 90;
    final entries = cart.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  "Delivery Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: Text(address),
                trailing: TextButton(
                  onPressed: () {
                    _showEditAddressDialog(context, ref);
                  },
                  child: const Text("Edit"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cart Items
            Text(
              "${entries.length} items",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: entries.map((e) {
                  final item = e.value;
                  final lineInr = item.totalPrice * 90;
                  return ListTile(
                    leading: Image.network(
                      item.product.image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${item.quantity} × ${formatter.format(item.product.price * 90)}",
                    ),
                    trailing: Text(
                      formatter.format(lineInr),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: Theme.of(context).textTheme.titleMedium),
                Text(
                  formatter.format(totalInr),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PaymentScreen(amount: (totalInr * 100).toInt()),
                    ),
                  );
                },
                child: const Text(
                  "Pay Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: ref.read(addressProvider));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Address"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter delivery address",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(addressProvider.notifier).state = controller.text;
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
