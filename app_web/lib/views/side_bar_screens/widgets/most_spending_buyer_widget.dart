import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MostSpendingBuyerWidget extends StatelessWidget {
  const MostSpendingBuyerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;

        // buyerId'lere göre harcamaları hesapla
        final Map<String, double> spendingByBuyer = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;

          final buyerId = data['buyerId'];
          final price = (data['price'] ?? 0).toDouble();
          final quantity = (data['quantity'] ?? 0).toDouble();

          final total = price * quantity;

          if (spendingByBuyer.containsKey(buyerId)) {
            spendingByBuyer[buyerId] = spendingByBuyer[buyerId]! + total;
          } else {
            spendingByBuyer[buyerId] = total;
          }
        }

        // En çok harcayan buyerId'yi bul
        String? topBuyerId;
        double maxSpending = 0;

        spendingByBuyer.forEach((buyerId, spending) {
          if (spending > maxSpending) {
            maxSpending = spending;
            topBuyerId = buyerId;
          }
        });

        if (topBuyerId == null) {
          return const Text("Veri yok");
        }

        // buyerId ile fullname al
        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('buyers')
                  .doc(topBuyerId)
                  .get(),
          builder: (context, buyerSnapshot) {
            if (!buyerSnapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final buyerData =
                buyerSnapshot.data!.data() as Map<String, dynamic>;
            final fullname = buyerData['fullname'] ?? "Bilinmiyor";

            return Card(
              color: Colors.deepPurple,
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
                      "Most Spending Buyer",
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
                      "${maxSpending.toStringAsFixed(2)} \$",
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
