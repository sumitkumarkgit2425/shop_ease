import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_ease/constant/app_color.dart';

import 'package:shop_ease/views/widgets/main_app_bar_widget.dart';
import 'package:shop_ease/views/widgets/menu_tile_widget.dart';
import 'package:shop_ease/views/widgets/notification_tile.dart';

import '../../data/models/Notification.dart';
import '../../data/services/NotificationService.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<UserNotification> listNotification =
      NotificationService.listNotification;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(chatValue: 2),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          MenuTileWidget(
            onTap: () {},
            icon: SvgPicture.asset(
              'assets/icons/Discount.svg',
              color: AppColor.secondary.withOpacity(0.5),
            ),
            title: 'Product Promo',
            subtitle: 'Lorem ipsum Dolor sit Amet',
          ),
          MenuTileWidget(
            onTap: () {},
            icon: SvgPicture.asset(
              'assets/icons/Info Square.svg',
              color: AppColor.secondary.withOpacity(0.5),
            ),
            title: 'shop_ease Info',
            subtitle: 'Lorem ipsum Dolor sit Amet',
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'ORDERS STATUS',
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.5),
                      letterSpacing: 6 / 100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return NotificationTile(
                      data: listNotification[index],
                      onTap: () {},
                    );
                  },
                  itemCount: listNotification.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
