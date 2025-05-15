import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mac_store_app/views/screens/nav_screens/widgets/popular_item_widget.dart';

class InnerVendorProductScreen extends StatefulWidget {
  final String vendorId;
  const InnerVendorProductScreen({super.key, required this.vendorId});

  @override
  State<InnerVendorProductScreen> createState() =>
      _InnerVendorProductScreenState();
}

class _InnerVendorProductScreenState extends State<InnerVendorProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query.toLowerCase();
      });
    });
  }

  Stream<QuerySnapshot> _getProductStream() {
    // Önce sadece vendorId'ye göre filtrele
    Query query = FirebaseFirestore.instance
        .collection('products')
        .where('vendorId', isEqualTo: widget.vendorId);

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getProductStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "Bu satıcıya ait ürün bulunmamaktadır",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // Arama filtrelemesi
                var filteredDocs = snapshot.data!.docs;
                if (searchQuery.isNotEmpty) {
                  filteredDocs = filteredDocs.where((doc) {
                    String productName =
                        doc['productName'].toString().toLowerCase();
                    return productName.contains(searchQuery);
                  }).toList();
                }

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Text(
                      "Aradığınız ürün bulunamadı",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return GridView.count(
                  padding: EdgeInsets.all(16),
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 300 / 500,
                  children: filteredDocs.map((doc) {
                    return PopularItem(productData: doc);
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
