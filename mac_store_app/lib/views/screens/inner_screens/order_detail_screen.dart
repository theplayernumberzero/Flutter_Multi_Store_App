import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends StatefulWidget {
  final dynamic orderData;

  OrderDetailScreen({super.key, required this.orderData});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double rating = 0;
  bool hasReview = false;

  @override
  void initState() {
    super.initState();
    checkUserReview();
  }

  void checkUserReview() async {
    final user = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReviews')
        .where('productId', isEqualTo: widget.orderData['productId'])
        .where('buyerId', isEqualTo: user!.uid)
        .get();

    setState(() {
      hasReview = querySnapshot.docs.isNotEmpty;
    });
  }

  Future<void> updateOrderRating(String productId, double newRating) async {
    final productRef = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.orderData['productId']);

    final productDoc = await productRef.get();
    if (productDoc.exists) {
      int currentRating = productDoc.data()?['rating'] ?? 0;

      await productRef.update({
        'rating': currentRating + newRating,
        'totalReviews': FieldValue.increment(1),
      });
    }
  }

  Widget buildReviewCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('productReviews')
          .where('productId', isEqualTo: widget.orderData['productId'])
          .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        if (snapshot.data!.docs.isEmpty) return const SizedBox();

        var reviewData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                "My Comment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
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
                            rating: reviewData['rating']?.toDouble() ?? 0,
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
              ),
            ),
          ],
        );
      },
    );
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
                                  color: Color(0xFFBCC5FF),
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
                                    SizedBox(height: 4),
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
                                    SizedBox(height: 2),
                                    Text(
                                      "\$${widget.orderData['price'] * widget.orderData['quantity']}",
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
                  color: Color(0xFFEFF0F2),
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
                        SizedBox(height: 12),
                        Text(
                          widget.orderData['locality'] +
                              " " +
                              widget.orderData['state'],
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                        Text(
                          widget.orderData['city'] ?? "",
                          style: GoogleFonts.lato(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "To " + widget.orderData['fullName'],
                          style: GoogleFonts.lato(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.orderData['delivered'] == true && !hasReview
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Leave a review"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: _reviewController,
                                      decoration: const InputDecoration(
                                          labelText: "Your review"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                          onRatingUpdate: (value) {
                                            rating = value;
                                          }),
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      final review = _reviewController.text;
                                      await FirebaseFirestore.instance
                                          .collection('productReviews')
                                          .doc(widget.orderData['orderId'])
                                          .set({
                                        'reviewId': widget.orderData['orderId'],
                                        'productId':
                                            widget.orderData['productId'],
                                        'fullName':
                                            widget.orderData['fullName'],
                                        'email': widget.orderData['email'],
                                        'buyerId': FirebaseAuth
                                            .instance.currentUser!.uid,
                                        'rating': rating.toDouble(),
                                        'review': review,
                                        'timeStamp': Timestamp.now(),
                                      }).whenComplete(() async {
                                        await updateOrderRating(
                                            widget.orderData['productId'],
                                            rating);
                                        Navigator.of(context).pop();
                                        _reviewController.clear();
                                        rating = 0;
                                        setState(() {
                                          hasReview = true;
                                        });
                                      });
                                    },
                                    child: const Text("Submit"),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text("Review")),
                )
              : const SizedBox(),
          if (hasReview) buildReviewCard(),
        ],
      ),
    );
  }
}
