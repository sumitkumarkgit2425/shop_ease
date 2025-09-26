import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ease/constant/app_color.dart';
import 'package:shop_ease/viewmodels/cart_viewmodel.dart';
import 'package:shop_ease/views/screens/cart_page.dart';
import 'package:shop_ease/views/screens/message_page.dart';
import 'package:shop_ease/views/screens/search_page.dart';
import 'package:shop_ease/views/widgets/custom_icon_button_widget.dart';
import 'package:shop_ease/views/widgets/dummy_search_widget2.dart';

class MainAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final int chatValue;

  const MainAppBar({super.key, required this.chatValue});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  ConsumerState<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends ConsumerState<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartCount = cart.entries.length;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: Row(
        children: [
          DummySearchWidget2(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          CustomIconButtonWidget(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            value: cartCount,
            margin: const EdgeInsets.only(left: 16),
            icon: SvgPicture.asset('assets/icons/Bag.svg', color: Colors.white),
          ),
          CustomIconButtonWidget(
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => MessagePage()));
            },
            value: widget.chatValue,
            margin: const EdgeInsets.only(left: 16),
            icon: SvgPicture.asset(
              'assets/icons/Chat.svg',
              color: Colors.white,
            ),
          ),
        ],
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
