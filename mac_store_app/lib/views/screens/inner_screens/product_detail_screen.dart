import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/favorite_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  Widget buildReviewCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('productReviews')
          .where('productId', isEqualTo: widget.productData['productId'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final reviews = snapshot.data!.docs;

        return reviews.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "No comments yet",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Text(
                      "Comments",
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var reviewData =
                            reviews[index].data() as Map<String, dynamic>;

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      reviewData['fullName'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating:
                                          reviewData['rating']?.toDouble() ?? 0,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  reviewData['review'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Product Detail",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            IconButton(
                onPressed: () {
                  favoriteProviderData.addProductToFavorite(
                      productName: widget.productData['productName'],
                      productId: widget.productData['productId'],
                      imageUrl: widget.productData['productImage'],
                      productPrice: widget.productData['productPrice'],
                      discount: widget.productData['discount']);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    margin: EdgeInsets.all(16),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey,
                    content: Text("Item added to favorite: " +
                        widget.productData['productName']),
                  ));
                },
                icon: favoriteProviderData.getFavoriteItem
                        .containsKey(widget.productData['productId'])
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      )),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 260,
                height: 274,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 50,
                      child: Container(
                        width: 260,
                        height: 260,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: Color(0xFFD8DDFF),
                            borderRadius: BorderRadius.circular(130)),
                      ),
                    ),
                    Positioned(
                      left: 22,
                      top: 0,
                      child: Container(
                        width: 216,
                        height: 274,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: Color(0xFF9CA8FF),
                            borderRadius: BorderRadius.circular(14)),
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                widget.productData['productImage'].length,
                            itemBuilder: (context, index) {
                              return Image.network(
                                  width: 198,
                                  height: 225,
                                  fit: BoxFit.cover,
                                  widget.productData['productImage'][index]);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productData['productName'],
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "\$${widget.productData['productPrice'].toStringAsFixed(2)}",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.black,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "\$${(widget.productData['productPrice'] - (widget.productData['productPrice'] * widget.productData['discount'] / 100)).toStringAsFixed(2)}",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Vendor Name: " + widget.productData['storeName'],
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.productData['category'],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            widget.productData['totalReviews'] == 0
                ? Text("")
                : Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(widget.productData['rating'].toString()),
                        Text(
                          " (${widget.productData['totalReviews']})",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
            widget.productData['category'] != "Fashion"
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Size: ",
                          style: GoogleFonts.lato(
                            color: Color(0xFF343434),
                            fontSize: 16,
                            letterSpacing: 1.6,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.productData['productSize'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF126881),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        widget.productData['productSize']
                                            [index],
                                        style: GoogleFonts.lato(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: GoogleFonts.lato(
                      color: Color(0xFF363330),
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(widget.productData['description'])
                ],
              ),
            ),
            buildReviewCard(),
            SizedBox(height: 60),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            cartProviderData.addProductToCard(
                productName: widget.productData['productName'],
                productPrice: widget.productData['productPrice'],
                categoryName: widget.productData['category'],
                imageUrl: widget.productData['productImage'],
                quantity: 1,
                inStock: widget.productData['quantity'],
                productId: widget.productData['productId'],
                productSize: '',
                discount: widget.productData['discount'],
                description: widget.productData['description'],
                vendorId: widget.productData['vendorId']);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              margin: EdgeInsets.all(16),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey,
              content: Text(
                  "Item added to cart: " + widget.productData['productName']),
            ));
          },
          child: widget.productData['quantity'] == 0
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Ürün maalesef tükenmiştir",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Container(
                  width: 386,
                  height: 48,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(24)),
                  child: Center(
                    child: Text(
                      "ADD TO CARD",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
