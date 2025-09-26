// category_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final String iconPath; // 👈 asset path instead of IconData
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 28, fit: BoxFit.contain),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                category,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getCategoryIconPath(String category) {
  switch (category.toLowerCase()) {
    case "electronics":
      return "assets/icons/device.png";
    case "jewelery":
      return "assets/icons/step.png";
    case "men's clothing":
      return "assets/icons/male-clothes.png";
    case "women's clothing":
      return "assets/icons/dress.png";
    default:
      return "assets/icons/device.png";
  }
}
