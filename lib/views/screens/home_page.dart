import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_ease/constant/app_color.dart';
import 'package:shop_ease/viewmodels/product_viewmodel.dart';
import 'package:shop_ease/views/screens/cart_page.dart';
import 'package:shop_ease/views/screens/message_page.dart';
import 'package:shop_ease/views/screens/search_page.dart';
import 'package:shop_ease/views/widgets/category_card.dart';
import 'package:shop_ease/views/widgets/custom_icon_button_widget.dart';
import 'package:shop_ease/views/widgets/dummy_search_widget_1.dart';
import 'package:shop_ease/views/widgets/flashsale_countdown_tile.dart';
import 'package:shop_ease/views/widgets/item_card.dart';

import '../../viewmodels/category_viewmodel.dart';
import 'cate_prd_page.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Timer flashsaleCountdownTimer;
  Duration flashsaleCountdownDuration = Duration(
    hours: 24 - DateTime.now().hour,
    minutes: 60 - DateTime.now().minute,
    seconds: 60 - DateTime.now().second,
  );

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    flashsaleCountdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountdown(),
    );
  }

  void setCountdown() {
    if (mounted) {
      setState(() {
        final seconds = flashsaleCountdownDuration.inSeconds - 1;
        if (seconds < 1) {
          flashsaleCountdownTimer.cancel();
        } else {
          flashsaleCountdownDuration = Duration(seconds: seconds);
        }
      });
    }
  }

  @override
  void dispose() {
    flashsaleCountdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String seconds = flashsaleCountdownDuration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String minutes = flashsaleCountdownDuration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String hours = flashsaleCountdownDuration.inHours
        .remainder(24)
        .toString()
        .padLeft(2, '0');

    final categoriesAsync = ref.watch(categoryViewModelProvider);
    final productsAsync = ref.watch(productViewModelProvider);
    final flashSaleProducts = ref.watch(flashSaleProvider);

    final double maxPrice = flashSaleProducts.isNotEmpty
        ? flashSaleProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b)
        : 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 26),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Find the best \noutfit for you.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            height: 150 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Row(
                          children: [
                            CustomIconButtonWidget(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CartScreen(),
                                  ),
                                );
                              },
                              value: 0,
                              icon: SvgPicture.asset(
                                'assets/icons/Bag.svg',
                                color: Colors.white,
                              ),
                            ),
                            CustomIconButtonWidget(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MessagePage(),
                                  ),
                                );
                              },
                              value: 2,
                              margin: const EdgeInsets.only(left: 16),
                              icon: SvgPicture.asset(
                                'assets/icons/Chat.svg',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DummySearchWidget1(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.secondary,
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'View More',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    height: 96,
                    child: categoriesAsync.when(
                      data: (categories) => ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryCard(
                            category: category,
                            iconPath: getCategoryIconPath(category),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryProductsScreen(
                                    category: category,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text("Error: $e")),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Flash Sale',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Row(
                          children: [
                            FlashsaleCountdownTile(digit: hours[0]),
                            FlashsaleCountdownTile(digit: hours[1]),
                            const Text(
                              ":",
                              style: TextStyle(color: Colors.white),
                            ),
                            FlashsaleCountdownTile(digit: minutes[0]),
                            FlashsaleCountdownTile(digit: minutes[1]),
                            const Text(
                              ":",
                              style: TextStyle(color: Colors.white),
                            ),
                            FlashsaleCountdownTile(digit: seconds[0]),
                            FlashsaleCountdownTile(digit: seconds[1]),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (flashSaleProducts.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      height: 310,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: flashSaleProducts.length,
                        itemBuilder: (context, index) {
                          final product = flashSaleProducts[index];
                          final progress = (product.price / maxPrice).clamp(
                            0.0,
                            1.0,
                          );

                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ItemCard(
                                  product: product,
                                  titleColor: Colors.grey,
                                  priceColor: Colors.yellowAccent,
                                ),
                                Container(
                                  width: 180,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: LinearProgressIndicator(
                                            minHeight: 10,
                                            value: progress,
                                            color: AppColor.accent,
                                            backgroundColor: AppColor.border,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.local_fire_department,
                                        color: AppColor.accent,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                'Todays recommendation...',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: productsAsync.when(
                data: (products) => Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: products
                      .map((p) => ItemCard(product: p))
                      .toList(growable: false),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
