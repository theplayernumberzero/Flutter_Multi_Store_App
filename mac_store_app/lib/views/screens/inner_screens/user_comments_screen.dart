import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserCommentsScreen extends StatefulWidget {
  const UserCommentsScreen({Key? key}) : super(key: key);

  @override
  State<UserCommentsScreen> createState() => _UserCommentsScreenState();
}

class _UserCommentsScreenState extends State<UserCommentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Comments',
          style: GoogleFonts.lato(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('productReviews')
            .where('buyerId', isEqualTo: _auth.currentUser!.uid)
            .snapshots(),
        builder: (context, reviewsSnapshot) {
          if (reviewsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reviewsSnapshot.hasError) {
            print('Error: ${reviewsSnapshot.error}');
            return Center(
                child: Text('Bir hata oluştu: ${reviewsSnapshot.error}'));
          }

          if (!reviewsSnapshot.hasData || reviewsSnapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Henüz yorum yapmadınız',
                style: GoogleFonts.lato(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: reviewsSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final reviewDoc = reviewsSnapshot.data!.docs[index];
              final reviewData = reviewDoc.data() as Map<String, dynamic>;

              if (reviewData['productId'] == null) {
                return const SizedBox();
              }

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('products')
                    .doc(reviewData['productId'])
                    .get(),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (productSnapshot.hasError) {
                    return const SizedBox();
                  }

                  if (!productSnapshot.hasData ||
                      !productSnapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final productData =
                      productSnapshot.data!.data() as Map<String, dynamic>;

                  if (productData['productImage'] == null ||
                      (productData['productImage'] as List).isEmpty) {
                    return const SizedBox();
                  }

                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  productData['productImage'][0],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productData['productName'],
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    FutureBuilder<QuerySnapshot>(
                                      future: _firestore
                                          .collection('orders')
                                          .where('productId',
                                              isEqualTo:
                                                  reviewData['productId'])
                                          .where('buyerId',
                                              isEqualTo: _auth.currentUser!.uid)
                                          .get(),
                                      builder: (context, orderSnapshot) {
                                        if (!orderSnapshot.hasData ||
                                            orderSnapshot.data!.docs.isEmpty) {
                                          return const SizedBox();
                                        }

                                        final orderData = orderSnapshot
                                            .data!.docs.first
                                            .data() as Map<String, dynamic>;

                                        return Text(
                                          '\$${orderData['price'].toStringAsFixed(2)}',
                                          style: GoogleFonts.lato(
                                            color: Colors.grey[600],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 24),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                reviewData['fullName'] ?? 'Anonim',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: List.generate(
                                  reviewData['rating'].toInt(),
                                  (index) => Icon(Icons.star,
                                      size: 18, color: Colors.amber),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            reviewData['review'],
                            style: GoogleFonts.lato(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(
                              (reviewData['timeStamp'] as Timestamp).toDate(),
                            ),
                            style: GoogleFonts.lato(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
