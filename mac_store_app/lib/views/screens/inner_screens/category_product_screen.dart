import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/models/category_models.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/popular_item_widget.dart';

class CategoryProductScreen extends StatelessWidget {
  final CategoryModels categoryModel;

  const CategoryProductScreen({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryModel.categoryName)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryModel.categoryName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No product under this category"),
            );
          }

          return GridView.count(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 300 / 500,
            children: List.generate(snapshot.data!.size, (index) {
              final productData = snapshot.data!.docs[index];
              return PopularItem(productData: productData);
            }),
          );
        },
      ),
    );
  }
}
