import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/vendor/views/screens/bottomNavigationBar/earnings_screen.dart';
import 'package:mac_store_app/vendor/views/screens/bottomNavigationBar/edit_product_screen.dart';
import 'package:mac_store_app/vendor/views/screens/bottomNavigationBar/upload_product_screen.dart';
import 'package:mac_store_app/vendor/views/screens/bottomNavigationBar/vendor_orders_screen.dart';
import 'package:mac_store_app/vendor/views/screens/bottomNavigationBar/vendor_profile_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int pageIndex = 0;
  final List<Widget> _pages = [
    EarningsScreen(),
    UploadProductScreen(),
    VendorOrdersScreen(),
    EditProductScreen(),
    //VendorProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.money), label: "Earning"),
            BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.cart), label: "Orders"),
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit"),
            //BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
      body: _pages[pageIndex],
    );
  }
}
