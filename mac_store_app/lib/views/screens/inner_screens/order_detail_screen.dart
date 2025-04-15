import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends StatefulWidget {
  //access all values of clicked data
  final dynamic orderData;

  OrderDetailScreen({super.key, required this.orderData});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double rating = 0;

  //check for user gave rating or not
  Future<bool> hasUserReviewedProduct(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .where('buyerId', isEqualTo: user!.uid)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  //update rating and review in product collection
  Future<void> updateProductRating(String productId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: productId)
        .get();
    double totalRating = 0;
    int totalReviews = querySnapshot.docs.length;
    for (final doc in querySnapshot.docs) {
      totalRating += doc['rating'];
    }

    final double averageRating =
        totalReviews > 0 ? totalRating / totalReviews : 0;

    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'rating': averageRating,
      'totalReviews': totalReviews,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orderData['productName']),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Container(
              width: 335,
              height: 153,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Container(
                        width: 335,
                        height: 153,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFFEFF0F2),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 12,
                              top: 8,
                              child: Container(
                                width: 78,
                                height: 78,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFFBCC5FF,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 10,
                                      top: 5,
                                      child: Image.network(
                                        widget.orderData['productImage'],
                                        width: 58,
                                        height: 68,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 101,
                      top: 14,
                      child: SizedBox(
                        width: 216,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        widget.orderData['productName'],
                                        style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.orderData['category'],
                                        style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Color(0xFF7F808C),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "\$${widget.orderData['price']}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 113,
                      left: 13,
                      child: Container(
                        width: 78,
                        height: 24,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: widget.orderData['delivered'] == true
                              ? Colors.green
                              : widget.orderData['processing'] == true
                                  ? Colors.deepPurpleAccent
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 4,
                              top: 3,
                              child: Text(
                                widget.orderData['delivered'] == true
                                    ? 'Delivered'
                                    : widget.orderData['processing'] == true
                                        ? 'Processing'
                                        : 'Cancelled',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: 336,
              height: 195,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(
                    0xFFEFF0F2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery address: ",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.orderData['locality'] +
                              " " +
                              widget.orderData['state'],
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                        Text(
                          "İstanbul",
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "To " + widget.orderData['fullName'],
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  widget.orderData['delivered'] == true
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                final productId = widget.orderData['productId'];
                                final hasReviewed =
                                    await hasUserReviewedProduct(productId);
                                if (hasReviewed) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Update your review"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: _reviewController,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "Update Your review"),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RatingBar.builder(
                                                    minRating: 1,
                                                    maxRating: 5,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemSize: 24,
                                                    initialRating: rating,
                                                    unratedColor: Colors.grey,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    itemBuilder: (context, _) {
                                                      return Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      );
                                                    },
                                                    onRatingUpdate: (value) {
                                                      rating = value;
                                                    }),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                final review =
                                                    _reviewController.text;
                                                //add will be add auto generate name
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'productReviews')
                                                    .doc(widget
                                                        .orderData['orderId'])
                                                    .update({
                                                  'reviewId': widget
                                                      .orderData['orderId'],
                                                  'productId': widget
                                                      .orderData['productId'],
                                                  'fullName': widget
                                                      .orderData['fullName'],
                                                  'email':
                                                      widget.orderData['email'],
                                                  'buyerId': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  'rating': rating,
                                                  'review': review,
                                                  'timeStamp': Timestamp.now(),
                                                }).whenComplete(() {
                                                  updateProductRating(
                                                      productId);
                                                  //remove dialog
                                                  Navigator.of(context).pop();
                                                  _reviewController.clear();
                                                  rating = 0;
                                                });
                                              },
                                              child: const Text("Submit"),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Leave a review"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: _reviewController,
                                                decoration: InputDecoration(
                                                    labelText: "Your review"),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RatingBar.builder(
                                                    minRating: 1,
                                                    maxRating: 5,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemSize: 24,
                                                    initialRating: rating,
                                                    unratedColor: Colors.grey,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4),
                                                    itemBuilder: (context, _) {
                                                      return Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      );
                                                    },
                                                    onRatingUpdate: (value) {
                                                      rating = value;
                                                    }),
                                              )
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                final review =
                                                    _reviewController.text;
                                                //add will be add auto generate name
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'productReviews')
                                                    .doc(widget
                                                        .orderData['orderId'])
                                                    .set({
                                                  'reviewId': widget
                                                      .orderData['orderId'],
                                                  'productId': widget
                                                      .orderData['productId'],
                                                  'fullName': widget
                                                      .orderData['fullName'],
                                                  'email':
                                                      widget.orderData['email'],
                                                  'buyerId': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  'rating': rating,
                                                  'review': review,
                                                  'timeStamp': Timestamp.now(),
                                                }).whenComplete(() {
                                                  updateProductRating(
                                                      productId);
                                                  //remove dialog
                                                  Navigator.of(context).pop();
                                                  _reviewController.clear();
                                                  rating = 0;
                                                });
                                              },
                                              child: const Text("Submit"),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                              child: Text("Review")),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
