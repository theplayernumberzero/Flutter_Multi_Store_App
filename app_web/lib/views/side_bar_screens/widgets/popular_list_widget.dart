import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PopularListWidget extends StatelessWidget {
  const PopularListWidget({super.key});

  Widget productDisplayData(Widget widget, int? flex) {
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
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
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
            final productData = snapshot.data!.docs[index];
            return Row(
              children: [
                productDisplayData(
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(productData['productImage'][0]),
                  ),
                  1,
                ),
                productDisplayData(
                  Text(
                    productData['storeName'],
                    style: TextStyle(color: Colors.white),
                  ),
                  1,
                ),
                productDisplayData(
                  Text(
                    productData['productName'],
                    style: TextStyle(color: Colors.white),
                  ),
                  1,
                ),
                productDisplayData(
                  Text(
                    productData['category'],
                    style: TextStyle(color: Colors.white),
                  ),
                  1,
                ),
                productDisplayData(
                  Text(
                    productData['productPrice'].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  1,
                ),
                productDisplayData(
                  Text(
                    productData['discount'].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  1,
                ),
                productDisplayData(
                  productData['isPopular'] == true
                      ? Text(
                        "Popular ⭐️",
                        style: TextStyle(color: Colors.yellow),
                      )
                      : ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(productData['productId'])
                              .update({'isPopular': true});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Arka plan rengi
                          foregroundColor: Colors.white, // Yazı rengi
                        ),
                        child: Text("Make Popular"),
                      ),
                  1,
                ),
                productDisplayData(
                  productData['isPopular'] == false
                      ? Text(
                        "Not Popular ⛔️",
                        style: TextStyle(color: Colors.red),
                      )
                      : ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(productData['productId'])
                              .update({'isPopular': false});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Arka plan rengi
                          foregroundColor: Colors.white, // Yazı rengi
                        ),
                        child: Text("Remove from popular"),
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
