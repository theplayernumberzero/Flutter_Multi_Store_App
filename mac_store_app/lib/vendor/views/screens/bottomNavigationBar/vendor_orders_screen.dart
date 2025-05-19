import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/vendor/views/screens/innerScreens/vendor_order_detail_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

class VendorOrdersScreen extends StatelessWidget {
  VendorOrdersScreen({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    //retrive all orders of current user only
    final Stream<QuerySnapshot> ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.2,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 118,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/icons/cartb.png',
              ),
            )),
            child: Stack(
              children: [
                Positioned(
                  left: 322,
                  top: 52,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/icons/not.png',
                        width: 26,
                        height: 25,
                      ),
                      // Positioned(
                      //   top: 0,
                      //   right: 0,
                      //   child: badges.Badge(
                      //     badgeStyle: badges.BadgeStyle(
                      //         badgeColor: Colors.orangeAccent),
                      //     badgeContent: Text(
                      //       cartData.length.toString(),
                      //       style: GoogleFonts.lato(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  left: 61,
                  top: 51,
                  child: Text(
                    "My Orders",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: ordersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "You have no order",
                      style: GoogleFonts.lato(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        },
                        child: Text(
                          "Go to Home Page",
                          style: GoogleFonts.lato(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final orderData = snapshot.data!.docs[index];
                return Padding(
                  padding: EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VendorOrderDetailScreen(
                                    orderData: orderData,
                                  )));
                    },
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 10,
                                              top: 5,
                                              child: Image.network(
                                                orderData['productImage'],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                orderData['productName'],
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
                                                orderData['category'],
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: Color(0xFF7F808C),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "\$${orderData['price']}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  "x ${orderData['quantity']}",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 24,
                                                ),
                                                Text(
                                                  "Total: ${orderData['price'] * orderData['quantity']}\$",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
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
                                  color: orderData['delivered'] == true
                                      ? Colors.green
                                      : orderData['processing'] == true
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
                                        orderData['delivered'] == true
                                            ? 'Delivered'
                                            : orderData['processing'] == true
                                                ? 'Processing'
                                                : 'Cancelled',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  orderData['delivered'] == true ? false : true,
                              child: Positioned(
                                top: 115,
                                left: 298,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        //burayı vendor kısmına ekleyip kullanıcıdan çekeceğim (delivered true olunca kullanıcı order silemez)
                                        child: GestureDetector(
                                          // Positioned widget içindeki GestureDetector'da onTap kısmını güncelle
                                          onTap: () async {
                                            try {
                                              // Önce ürün stokunu güncelle
                                              await _firestore
                                                  .collection('products')
                                                  .doc(orderData['productId'])
                                                  .update({
                                                'quantity':
                                                    FieldValue.increment(
                                                        orderData['quantity']),
                                              });

                                              // Sonra siparişi sil
                                              await _firestore
                                                  .collection('orders')
                                                  .doc(orderData['orderId'])
                                                  .delete();
                                            } catch (e) {
                                              print(
                                                  'Error updating stock and deleting order: $e');
                                            }
                                          },
                                          child: Image.asset(
                                            'assets/icons/delete.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
