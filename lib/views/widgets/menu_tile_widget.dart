import 'package:flutter/material.dart';
import 'package:shop_ease/constant/app_color.dart';

class MenuTileWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final Color iconBackground;
  final Color titleColor;

  MenuTileWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.margin = EdgeInsets.zero,
    this.iconBackground = AppColor.primarySoft,
    this.titleColor = AppColor.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColor.primarySoft, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: icon,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),

                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        fontSize: 12,
                        fontFamily: 'poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColor.border),
          ],
        ),
      ),
    );
  }
}
