import 'package:app_web/views/side_bar_screens/buyers_screen.dart';
import 'package:app_web/views/side_bar_screens/category_screen.dart';
import 'package:app_web/views/side_bar_screens/orders_screen.dart';
import 'package:app_web/views/side_bar_screens/products_screen.dart';
import 'package:app_web/views/side_bar_screens/upload_banner_screen.dart';
import 'package:app_web/views/side_bar_screens/vendors_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = VendorsScreen();

  screenSelector(item) {
    switch (item.route) {
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = BuyersScreen();
        });
        break;
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = VendorsScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
        });
        break;
      case OrdersScreen.id:
        setState(() {
          _selectedScreen = OrdersScreen();
        });
        break;
      case ProductsScreen.id:
        setState(() {
          _selectedScreen = ProductsScreen();
        });
        break;
      case UploadBannerScreen.id:
        setState(() {
          _selectedScreen = UploadBannerScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Management",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 4,
          ),
        ),
      ),
      //with named route we can navigate between screens
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity, //Give width of sidebar
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Text(
              "Multi Vendor Admin",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity, //Give width of sidebar
          color: Colors.black,
          child: Center(
            child: Text(
              "Footer",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        items: [
          AdminMenuItem(
            title: 'Vendors',
            route: VendorsScreen.id,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrdersScreen.id,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: CategoryScreen.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: 'Upload Banner',
            route: UploadBannerScreen.id,
            icon: Icons.add,
          ),
          AdminMenuItem(
            title: 'Products',
            route: ProductsScreen.id,
            icon: Icons.store,
          ),
        ],
        onSelected: (item) {
          screenSelector(item);
        },
        selectedRoute: VendorsScreen.id,
      ),
      body: _selectedScreen,
    );
  }
}
