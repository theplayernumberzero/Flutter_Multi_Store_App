import 'package:app_web/views/side_bar_screens/widgets/most_earning_vendor_widget.dart';
import 'package:app_web/views/side_bar_screens/widgets/most_spending_buyer_widget.dart';
import 'package:app_web/views/side_bar_screens/widgets/statistic_counts_widget.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  static const String id = "/statistics-screen";
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Text(
                  "Statistics",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Count's",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: GridView.count(
              crossAxisCount: 6,
              padding: const EdgeInsets.all(12),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                statistic_counts_widget("Total Buyer", "buyers", Colors.blue),
                statistic_counts_widget(
                  "Total Vendor",
                  "vendors",
                  Colors.green,
                ),
                statistic_counts_widget(
                  "Total orders",
                  "orders",
                  Colors.orange,
                ),
                statistic_counts_widget(
                  "Total product reviews",
                  "productReviews",
                  Colors.purple,
                ),
                statistic_counts_widget(
                  "Total categories",
                  "categories",
                  Colors.teal,
                ),
                statistic_counts_widget(
                  "Total products",
                  "products",
                  Colors.red,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Most's",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [MostEarningVendorWidget(), MostSpendingBuyerWidget()],
          ),
        ],
      ),
    );
  }
}
