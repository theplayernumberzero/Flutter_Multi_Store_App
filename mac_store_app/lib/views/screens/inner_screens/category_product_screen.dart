import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mac_store_app/models/category_models.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/popular_item_widget.dart';

class CategoryProductScreen extends StatefulWidget {
  final CategoryModels categoryModel;

  const CategoryProductScreen({super.key, required this.categoryModel});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;
  String? selectedSortOption;
  String? appliedSortOption;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query.toLowerCase();
      });
    });
  }

  Stream<QuerySnapshot> _getProductStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.categoryModel.categoryName)
        .snapshots();
  }

  void _applyFilter() {
    setState(() {
      appliedSortOption = selectedSortOption;
    });
  }

  void _clearFilters() {
    setState(() {
      selectedSortOption = null;
      appliedSortOption = null;
    });
  }

  List<QueryDocumentSnapshot> _sortProducts(
      List<QueryDocumentSnapshot> products) {
    switch (appliedSortOption) {
      case 'price_asc':
        products.sort((a, b) {
          double priceA =
              a['productPrice'] - (a['productPrice'] * a['discount'] / 100);
          double priceB =
              b['productPrice'] - (b['productPrice'] * b['discount'] / 100);
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_desc':
        products.sort((a, b) {
          double priceA =
              a['productPrice'] - (a['productPrice'] * a['discount'] / 100);
          double priceB =
              b['productPrice'] - (b['productPrice'] * b['discount'] / 100);
          return priceB.compareTo(priceA);
        });
        break;
      case 'discount_asc':
        products.sort(
            (a, b) => (a['discount'] as num).compareTo(b['discount'] as num));
        break;
      case 'discount_desc':
        products.sort(
            (a, b) => (b['discount'] as num).compareTo(a['discount'] as num));
        break;
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryModel.categoryName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
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
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedSortOption,
                            hint: Text('Select Filter'),
                            underline: SizedBox(),
                            items: [
                              DropdownMenuItem(
                                value: 'price_asc',
                                child: Text('Sort by price (Low to High)'),
                              ),
                              DropdownMenuItem(
                                value: 'price_desc',
                                child: Text('Sort by price (High to Low)'),
                              ),
                              DropdownMenuItem(
                                value: 'discount_asc',
                                child: Text('Sort by discount (Low to High)'),
                              ),
                              DropdownMenuItem(
                                value: 'discount_desc',
                                child: Text('Sort by discount (High to Low)'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedSortOption = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _applyFilter,
                        child: Text('Filter'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _clearFilters,
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getProductStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No products available in this category",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  var filteredDocs = snapshot.data!.docs;

                  if (searchQuery.isNotEmpty) {
                    filteredDocs = filteredDocs.where((doc) {
                      String productName =
                          doc['productName'].toString().toLowerCase();
                      return productName.contains(searchQuery);
                    }).toList();
                  }

                  if (appliedSortOption != null) {
                    filteredDocs = _sortProducts(filteredDocs);
                  }

                  if (filteredDocs.isEmpty) {
                    return Center(
                      child: Text(
                        "No products found matching your search",
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
      ),
    );
  }
}
