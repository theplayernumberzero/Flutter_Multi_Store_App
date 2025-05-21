import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/views/screens/inner_screens/order_detail_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedFilter = 'Newest First';
  Stream<QuerySnapshot>? ordersStream;
  bool isProcessingFilter = false;

  @override
  void initState() {
    super.initState();
    ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  void applyFilter() {
    setState(() {
      var query = FirebaseFirestore.instance
          .collection('orders')
          .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

      if (isProcessingFilter) {
        query = query.where('processing', isEqualTo: true);
      }

      ordersStream = query
          .orderBy('createdAt',
              descending: selectedFilter == 'Newest First' ? true : false)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  left: 16,
                  top: 40,
                  child: Text(
                    "My Orders",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedFilter,
                            items: ['Newest First', 'Oldest First']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFilter = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: applyFilter,
                        child: Text('Filtrele'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isProcessingFilter,
                        onChanged: (bool? value) {
                          setState(() {
                            isProcessingFilter = value ?? false;
                          });
                        },
                      ),
                      Text('Is Processing'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ordersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                    builder: (context) => OrderDetailScreen(
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      orderData['category'],
                                                      style: GoogleFonts.lato(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF7F808C),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "\$${orderData['price'] * orderData['quantity']}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
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
                                                  : orderData['processing'] ==
                                                          true
                                                      ? 'Processing'
                                                      : 'Cancelled',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
