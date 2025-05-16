import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/vendor/views/screens/bottomNavigationBar/upload_product_screen.dart';
import 'package:mac_store_app/vendor/views/screens/innerScreens/edit_product_detail_screen.dart';
import 'package:mac_store_app/vendor/views/screens/main_vendor_screen.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocumentCount();
  }

  int productCount = 0;

  //Hem init state içinde hem de silme işleminde kullanılacak
  Future<void> getDocumentCount() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      productCount = querySnapshot.docs.length;
    });

    //print("Document count: $count");
  }

  @override
  Widget build(BuildContext context) {
    //retrive all orders of current user only
    final Stream<QuerySnapshot> ordersStream = FirebaseFirestore.instance
        .collection('products')
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
                  left: 260,
                  top: 52,
                  child: Stack(
                    children: [
                      Text(
                        "Product Count: " + productCount.toString(),
                        style: TextStyle(color: Colors.white),
                      )
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
                    "My Products",
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
                      "You have no products",
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
                                  builder: (context) => UploadProductScreen()));
                        },
                        child: Text(
                          "Upload product",
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
                final productData = snapshot.data!.docs[index];
                return Padding(
                  padding: EdgeInsets.all(12),
                  child: Container(
                    width: 335,
                    height: 100,
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            left: 10,
                                            top: 5,
                                            child: Image.network(
                                              productData['productImage'][0],
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
                                              productData['productName'],
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
                                              productData['category'],
                                              style: GoogleFonts.lato(
                                                fontSize: 12,
                                                color: Color(0xFF7F808C),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          //düzenleme yapılacak
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "\$${productData['productPrice']}",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    "\$${productData['productPrice'] - (productData['productPrice'] * productData['discount'] / 100)}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                            top: 60,
                            left: 280,
                            child: Container(
                              width: 100,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text("Ürünü Sil"),
                                            content: Text(
                                                "Silmek istediğinize emin misiniz?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx)
                                                        .pop(false),
                                                child: Text("Hayır"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(true),
                                                child: Text("Evet"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("products")
                                                .doc(productData[
                                                    'productId']) // burada product, o anki doküman
                                                .delete();

                                            if (!context.mounted) return;
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      MainVendorScreen()),
                                              (route) => false,
                                            );
                                            Future.delayed(
                                                Duration(milliseconds: 300),
                                                () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Ürün başarıyla silindi')),
                                              );
                                            });
                                          } catch (e) {
                                            print("Silme hatası: $e");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Bir hata oluştu. Lütfen tekrar deneyin.")),
                                            );
                                          }
                                        }
                                      },
                                      child: Image.asset(
                                        'assets/icons/delete.png',
                                        width: 30,
                                        height: 30,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 60,
                                    //burayı vendor kısmına ekleyip kullanıcıdan çekeceğim (delivered true olunca kullanıcı order silemez)
                                    child: GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProductDetailScreen(
                                                        product: productData,
                                                      )));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          size: 30,
                                          color: Colors.blue,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
