import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderListWidget extends StatelessWidget {
  const OrderListWidget({super.key});

  Widget orderDisplayData(Widget widget, int? flex) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey),
          child: Padding(padding: const EdgeInsets.all(8.0), child: widget),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream =
        FirebaseFirestore.instance.collection('orders').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _ordersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        //list view belli bir height olmadığı için shrinkWrap aktive edilmeli.
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            final orderData = snapshot.data!.docs[index];
            return Row(
              children: [
                orderDisplayData(
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(orderData['productImage']),
                  ),
                  1,
                ),
                orderDisplayData(
                  Text(
                    orderData['fullName'],
                    style: TextStyle(color: Colors.white),
                  ),
                  3,
                ),
                orderDisplayData(
                  Text(
                    "${orderData['state']} / ${orderData['locality']}",
                    style: TextStyle(color: Colors.white),
                  ),
                  2,
                ),
                orderDisplayData(
                  orderData['delivered'] == true
                      ? Text(
                        "Delivered ✅",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      )
                      : ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orderData['orderId'])
                              .update({
                                'delivered': true,
                                'processing': false,
                                'deliveredCount': FieldValue.increment(1),
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Arka plan rengi
                          foregroundColor: Colors.white, // Yazı rengi
                        ),
                        child: Text(
                          "Mark Delivered",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  1,
                ),
                orderDisplayData(
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderData['orderId'])
                          .update({'delivered': false, 'processing': false});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Arka plan rengi
                      foregroundColor: Colors.white, // Yazı rengi
                    ),
                    child: Text("Cancel"),
                  ),
                  1,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
