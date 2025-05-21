import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class AllCommentsScreen extends StatefulWidget {
  static const String id = "/allCommentsScreen";
  const AllCommentsScreen({super.key});

  @override
  State<AllCommentsScreen> createState() => _AllCommentsScreenState();
}

class _AllCommentsScreenState extends State<AllCommentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteReview(
    String productId,
    String reviewId,
    double rating,
  ) async {
    // Silme onayı dialog'u
    bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Yorumu Sil'),
            content: const Text(
              'Bu yorumu silmek istediğinizden emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Evet, Sil'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );

    if (shouldDelete ?? false) {
      try {
        // Products collection'ını güncellediğim yer
        DocumentReference productRef = _firestore
            .collection('products')
            .doc(productId);

        //bu blokta yapılan işlemler ya tamamen başarılı olur, ya da hiçbiri uygulanmaz.
        await _firestore.runTransaction((transaction) async {
          DocumentSnapshot productSnapshot = await transaction.get(productRef);

          if (productSnapshot.exists) {
            Map<String, dynamic> data =
                productSnapshot.data() as Map<String, dynamic>;
            int currentTotalReviews = data['totalReviews'] ?? 0;
            double currentRating = data['rating'] ?? 0.0;

            int newTotalReviews = currentTotalReviews - 1;
            double newRating = currentRating - rating;

            // Güncelleme işlemi
            transaction.update(productRef, {
              'totalReviews': newTotalReviews,
              'rating': newRating,
            });
          }
        });

        // Review'u sil
        await _firestore.collection('productReviews').doc(reviewId).delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yorum başarıyla silindi')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Comments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('productReviews').snapshots(),
        builder: (context, reviewSnapshot) {
          if (reviewSnapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          }

          if (reviewSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: reviewSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final reviewDoc = reviewSnapshot.data!.docs[index];
                final reviewData = reviewDoc.data() as Map<String, dynamic>;

                return FutureBuilder<DocumentSnapshot>(
                  future:
                      _firestore
                          .collection('products')
                          .doc(reviewData['productId'])
                          .get(),
                  builder: (context, productSnapshot) {
                    if (!productSnapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    final productData =
                        productSnapshot.data!.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  child: const Icon(Icons.person),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewData['fullName'] ?? 'Anonymous',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Vendor name: " +
                                            productData['storeName'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _deleteReview(
                                        reviewData['productId'],
                                        reviewDoc.id,
                                        (reviewData['rating'] ?? 0).toDouble(),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            (reviewData['rating'] ?? 0)
                                                .toDouble(),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        ignoreGestures: true,
                                        itemBuilder:
                                            (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        reviewData['review'] ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        reviewData['timeStamp'] != null
                                            ? DateFormat('dd.MM.yyyy').format(
                                              reviewData['timeStamp'].toDate(),
                                            )
                                            : '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
