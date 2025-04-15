import 'package:app_web/views/side_bar_screens/widgets/popular_list_widget.dart';
import 'package:flutter/material.dart';

class IsPopularScreen extends StatelessWidget {
  static const String id = "/is-popular";
  const IsPopularScreen({super.key});

  Widget rowHeader(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Popular Products',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              rowHeader(1, 'Product Image'),
              rowHeader(1, 'Store Name'),
              rowHeader(1, 'Product Name'),
              rowHeader(1, 'Category'),
              rowHeader(1, 'Product Price'),
              rowHeader(1, 'Discount (%)'),
              rowHeader(1, 'Is Popular'),
              rowHeader(1, 'Is Not Popular'),
            ],
          ),
          PopularListWidget(),
        ],
      ),
    );
  }
}
