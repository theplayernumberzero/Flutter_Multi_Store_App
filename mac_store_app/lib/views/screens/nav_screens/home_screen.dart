import 'package:flutter/material.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/category_item.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/popular_products_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/recommended_product_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/reuseable_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(),
            BannerWidget(),
            CategoryItem(),
            ReuseableTextWidget(
                title: 'Top 5 Rated Products', subtitle: 'View all'),
            RecommendedProductWidget(),
            ReuseableTextWidget(
                title: 'Popular Products', subtitle: 'View all'),
            PopularProductsWidget(),
          ],
        ),
      ),
    );
  }
}
