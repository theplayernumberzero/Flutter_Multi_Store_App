import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/producut_item_widget.dart';

class PopularProductsWidget extends StatelessWidget {
  const PopularProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Data we want to stream
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('isPopular', isEqualTo: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var products = snapshot.data!.docs;
        if (products.toList().length >= 5) {
          products = products.take(5).toList();
        } else {}

        return SizedBox(
          height: 250,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final productData = products[index];
                return ProducutItemWidget(
                  productData: productData,
                );
              }),
        );
      },
    );
  }
}
