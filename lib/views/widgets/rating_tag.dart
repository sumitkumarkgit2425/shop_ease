import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_ease/constant/app_color.dart';

class RatingTag extends StatelessWidget {
  final double? value;
  final EdgeInsetsGeometry margin;

  const RatingTag({super.key, this.value, required this.margin});

  @override
  Widget build(BuildContext context) {
    final rating = value ?? 0.0;
    return Container(
      width: 50,
      margin: margin,
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 5, right: 8),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/Star-active.svg',
            width: 14,
            height: 14,
          ),
          const SizedBox(width: 4),
          Text(
            rating > 0 ? rating.toStringAsFixed(1) : "N/A", // ✅ safe display
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
