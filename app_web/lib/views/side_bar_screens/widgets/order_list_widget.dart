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
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('vendors')
                      .where('uid', isEqualTo: orderData['vendorId'])
                      .limit(1)
                      .get()
                      .then((querySnapshot) => querySnapshot.docs.first),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Yükleniyor...',
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Hata oluştu',
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text(
                        'Vendor bulunamadı',
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final vendorData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final vendorFullName =
                        vendorData['fullname'] ?? 'Bilinmiyor';

                    return orderDisplayData(
                      Text(
                        vendorFullName,
                        style: TextStyle(color: Colors.white),
                      ),
                      2,
                    );
                  },
                ),
                orderDisplayData(
                  Text(
                    orderData['fullName'],
                    style: TextStyle(color: Colors.white),
                  ),
                  2,
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
                      : Text(
                        "Processing",
                        style: TextStyle(color: Colors.amber),
                        textAlign: TextAlign.center,
                      ),
                  2,
                ),
                orderDisplayData(
                  Text(
                    orderData['price'].toString() + " \$",
                    style: TextStyle(color: Colors.white),
                  ),
                  1,
                ),
                orderDisplayData(
                  Text(
                    orderData['quantity'].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  1,
                ),
                orderDisplayData(
                  Text(
                    (orderData['price'] * orderData['quantity']).toString() +
                        " \$",
                    style: TextStyle(color: Colors.white),
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
