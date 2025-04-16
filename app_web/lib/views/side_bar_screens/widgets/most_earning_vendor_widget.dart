import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MostEarningVendorWidget extends StatelessWidget {
  const MostEarningVendorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;

        // vendorId'lere göre kazançları tutacağım değişken
        final Map<String, double> earningsByVendor = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;

          final vendorId = data['vendorId'];
          final price = (data['price'] ?? 0).toDouble();
          final quantity = (data['quantity'] ?? 0).toDouble();

          final total = price * quantity;

          if (earningsByVendor.containsKey(vendorId)) {
            earningsByVendor[vendorId] = earningsByVendor[vendorId]! + total;
          } else {
            earningsByVendor[vendorId] = total;
          }
        }

        // En çok kazanan vendorId'yi burada buluyoruz
        String? topVendorId;
        double maxEarning = 0;

        earningsByVendor.forEach((vendorId, earning) {
          if (earning > maxEarning) {
            maxEarning = earning;
            topVendorId = vendorId;
          }
        });

        // vendor yoksa burası çalışacak
        if (topVendorId == null) {
          return const Text("Veri yok");
        }

        // vendorun ismini çektiğim yer
        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(topVendorId)
                  .get(),
          builder: (context, vendorSnapshot) {
            if (!vendorSnapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final vendorData =
                vendorSnapshot.data!.data() as Map<String, dynamic>;
            final fullname = vendorData['fullname'] ?? "Bilinmiyor";

            return Card(
              color: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Most Earning Vendor",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fullname,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${maxEarning.toStringAsFixed(2)} \$",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
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
  }
}
