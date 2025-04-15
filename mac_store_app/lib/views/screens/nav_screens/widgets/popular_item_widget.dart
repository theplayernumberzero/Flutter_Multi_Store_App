import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/views/screens/inner_screens/product_detail_screen.dart';

class PopularItem extends StatelessWidget {
  const PopularItem({
    super.key,
    required this.productData,
  });

  final QueryDocumentSnapshot<Object?> productData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductDetailScreen(productData: productData)));
      },
      child: SizedBox(
        width: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              //force image to have border radius
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 88,
                height: 80,
                decoration: BoxDecoration(
                    color: Color(0xFFB0CCFF),
                    borderRadius: BorderRadius.circular(6)),
                child: Image.network(
                  productData['productImage'][0],
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "\$${productData['productPrice'] - (productData['productPrice'] * productData['discount'] / 100)}",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              productData['productName'],
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
