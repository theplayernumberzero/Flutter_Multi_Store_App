import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/views/screens/inner_screens/shipping_address_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedPaymentMethod = 'stripe';

  // Kullanıcı bilgileri
  String state = '';
  String city = '';
  String locality = '';
  String pincode = '';

  @override
  void initState() {
    super.initState();
    // Tek seferlik veri çekme işlemi yapalım
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await _firestore
          .collection('buyers')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userData.exists && mounted) {
        setState(() {
          state = userData.get('state') ?? '';
          city = userData.get('city') ?? '';
          locality = userData.get('locality') ?? '';
          pincode = userData.get('pincode') ?? '';
        });
      }
    } catch (e) {
      print('Kullanıcı verisi yüklenirken hata: $e');
    }
  }

  // ShippingAddressScreen'den dönüşte veriyi yenile
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchUserData();
  }

  @override
  void dispose() {
    // Gelecekte eklenebilecek controller'lar veya dispose edilmesi gereken
    // kaynaklar için bu metodu tutuyoruz
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.read(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("CheckOut"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShippingAddressScreen()));
                },
                child: SizedBox(
                  width: 335,
                  height: 74,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 335,
                          height: 74,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFEFF0F2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 17,
                        left: 70,
                        child: SizedBox(
                          width: 215,
                          height: 40,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: -1,
                                top: -1,
                                child: SizedBox(
                                  width: 220,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Add address",
                                          style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Enter city",
                                          style: GoogleFonts.lato(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              height: 1.4,
                                              color: Colors.grey),
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
                        left: 16,
                        top: 16,
                        child: SizedBox.square(
                          dimension: 42,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFBF7F5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        left: 11,
                                        top: 11,
                                        child: Icon(
                                          Icons.location_city,
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
                        left: 305,
                        top: 25,
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Your item",
                style:
                    GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: cartProviderData.length,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    final cartItem = cartProviderData.values.toList()[index];

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 336,
                        height: 91,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFEFF0F2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 6,
                              top: 6,
                              child: SizedBox(
                                width: 311,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 78,
                                      height: 78,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFBCC5FF),
                                      ),
                                      child:
                                          Image.network(cartItem.imageUrl[0]),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 78,
                                        alignment: Alignment(0, -0.5),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  cartItem.productName,
                                                  style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.3),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  cartItem.categoryName,
                                                  style: GoogleFonts.lato(
                                                    color: Colors.blueGrey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      (cartItem.quantity *
                                              (cartItem.productPrice -
                                                  cartItem.productPrice *
                                                      cartItem.discount /
                                                      100))
                                          .toStringAsFixed(2),
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.purple,
                                        height: 1.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                "Choose payment method",
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RadioListTile<String>(
                  title: Text("Stripe"),
                  value: 'stripe',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  }),
              RadioListTile<String>(
                  title: Text("Cash On Delivery"),
                  value: 'cashOnDelivery',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  }),
            ],
          ),
        ),
      ),
      bottomSheet: (state == "" ||
              city == "" ||
              locality == "" ||
              pincode == "")
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () async {
                    // async ekledik
                    await Navigator.push(
                        // await ekledik
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShippingAddressScreen()));
                    // ShippingAddressScreen'den döndükten sonra verileri yenile
                    await _fetchUserData();
                  },
                  child: Text(
                    "Add address",
                    style: TextStyle(fontSize: 20),
                  )),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () async {
                  if (_selectedPaymentMethod == 'stripe') {
                    // Stripe işlemleri burada olacak
                  } else {
                    setState(() {
                      isLoading = true;
                    });

                    bool hasStockError = false;

                    for (var item in ref
                        .read(cartProvider.notifier)
                        .getCartItem
                        .values
                        .toList()) {
                      // Ürünün bilgisi
                      DocumentSnapshot productDoc = await _firestore
                          .collection('products')
                          .doc(item.productId)
                          .get();

                      if (!productDoc.exists) {
                        hasStockError = true;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${item.productName} bulunamadı.'),
                        ));
                        break;
                      }

                      int currentStock = productDoc.get('quantity');

                      // stok kontrol
                      if (item.quantity > currentStock) {
                        hasStockError = true;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${item.productName} için yeterli stok yok. Mevcut: $currentStock'),
                        ));
                        break;
                      }
                    }

                    if (hasStockError) {
                      setState(() {
                        isLoading = false;
                      });
                      return;
                    }

                    //Stok varsa işlemi yap
                    for (var item in ref
                        .read(cartProvider.notifier)
                        .getCartItem
                        .values
                        .toList()) {
                      DocumentSnapshot userDoc = await _firestore
                          .collection("buyers")
                          .doc(_auth.currentUser!.uid)
                          .get();

                      final orderId = Uuid().v4();

                      await _firestore.collection('orders').doc(orderId).set({
                        'orderId': orderId,
                        'productName': item.productName,
                        'productId': item.productId,
                        'size': item.productSize,
                        'quantity': item.quantity,
                        'price': (item.productPrice -
                            item.productPrice * item.discount / 100),
                        'category': item.categoryName,
                        'productImage': item.imageUrl[0],
                        'state':
                            (userDoc.data() as Map<String, dynamic>)['state'],
                        'email':
                            (userDoc.data() as Map<String, dynamic>)['email'],
                        'locality': (userDoc.data()
                            as Map<String, dynamic>)['locality'],
                        'fullName': (userDoc.data()
                            as Map<String, dynamic>)['fullname'],
                        'buyerId': _auth.currentUser!.uid,
                        'deliveredCount': 0,
                        'delivered': false,
                        'city':
                            (userDoc.data() as Map<String, dynamic>)['city'],
                        'processing': true,
                        'vendorId': item.vendorId,
                      });

                      //product güncelle
                      await _firestore
                          .collection('products')
                          .doc(item.productId)
                          .update({
                        'quantity': FieldValue.increment(-item.quantity),
                      });
                    }

                    cartProviderData.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('İşlem başarılı')),
                    );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "PLACE ORDER",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                  ),
                ),
              ),
            ),
    );
  }
}
