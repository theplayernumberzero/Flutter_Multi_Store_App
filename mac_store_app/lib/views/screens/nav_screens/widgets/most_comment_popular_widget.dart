import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/producut_item_widget.dart';

class MostCommentPopularWidget extends StatelessWidget {
  const MostCommentPopularWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //Data we want to stream
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('totalReviews',
            isGreaterThan: 0) // totalReviews 0'dan büyük olanları filtrele
        .orderBy('totalReviews',
            descending: true) // totalReviews'a göre azalan sırada sırala
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
