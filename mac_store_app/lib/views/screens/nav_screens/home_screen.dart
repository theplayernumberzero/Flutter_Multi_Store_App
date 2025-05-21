import 'package:flutter/material.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/category_item.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/header_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/most_comment_popular_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/popular_products_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/recommended_product_widget.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/reusable_text_widget_popular.dart';
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
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 8),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
            CategoryItem(),
            ReuseableTextWidget(
                title: 'Top 5 Rated Products', subtitle: 'View all products'),
            RecommendedProductWidget(),
            ReusableTextWidgetPopular(
              title: 'Popular Products',
            ),
            PopularProductsWidget(),
            ReusableTextWidgetPopular(
              title: 'Most Comment',
            ),
            MostCommentPopularWidget(),
          ],
        ),
      ),
    );
  }
}
