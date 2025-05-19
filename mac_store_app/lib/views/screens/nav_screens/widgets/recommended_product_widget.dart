import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/producut_item_widget.dart';

class RecommendedProductWidget extends StatelessWidget {
  const RecommendedProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();

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

        // Tüm ürünleri bir liste olarak alıyoruz
        final products = snapshot.data!.docs;

        // Her ürün için currentRating hesaplıyoruz ve sıralıyoruz
        products.sort((a, b) {
          final aRating = a['rating'] as num;
          final aTotalReviews =
              (a['totalReviews'] as num) == 0 ? 1 : a['totalReviews'] as num;
          final aCurrentRating = aRating / aTotalReviews;

          final bRating = b['rating'] as num;
          final bTotalReviews =
              (b['totalReviews'] as num) == 0 ? 1 : b['totalReviews'] as num;
          final bCurrentRating = bRating / bTotalReviews;

          // Büyükten küçüğe sıralama için b'den a'yı çıkarıyoruz
          return bCurrentRating.compareTo(aCurrentRating);
        });

        // Sadece ilk 5 ürünü alıyoruz
        final topProducts = products.take(5).toList();

        return SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topProducts.length,
            itemBuilder: (context, index) {
              final productData = topProducts[index];
              return ProducutItemWidget(
                productData: productData,
              );
            },
          ),
        );
      },
    );
  }
}
