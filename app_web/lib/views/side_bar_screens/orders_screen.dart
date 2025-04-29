import 'package:app_web/views/side_bar_screens/widgets/order_list_widget.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  static const String id = "/orders-screen";
  const OrdersScreen({super.key});

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
                'Manage Orders',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              rowHeader(1, 'Image'),
              rowHeader(2, 'Vendor Name'),
              rowHeader(2, 'Buyer Name'),
              rowHeader(2, 'Address'),
              rowHeader(2, 'Is Delivered'),
              rowHeader(1, 'Price'),
              rowHeader(1, 'Quantity'),
              rowHeader(1, 'Total'),
            ],
          ),
          OrderListWidget(),
        ],
      ),
    );
  }
}
