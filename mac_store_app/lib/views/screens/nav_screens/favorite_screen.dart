import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/provider/favorite_provider.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteData = ref.read(favoriteProvider.notifier);
    final wishItemData = ref.watch(favoriteProvider);
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
                        Positioned(
                          top: 0,
                          right: 0,
                          child: badges.Badge(
                            badgeStyle: badges.BadgeStyle(
                                badgeColor: Colors.orangeAccent),
                            badgeContent: Text(
                              wishItemData.length.toString(),
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 61,
                    top: 51,
                    child: Text(
                      "My Favorite",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            )),
        body: wishItemData.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Your Wish List is empty\nYou can add item to your wishlist from\nbutton below",
                      style:
                          GoogleFonts.roboto(fontSize: 18, letterSpacing: 1.7),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        },
                        child: Text(
                          "ADD NOW",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ))
                  ],
                ),
              )
            : ListView.builder(
                itemCount: wishItemData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final wishData = wishItemData.values.toList()[index];
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Container(
                        width: 335,
                        height: 96,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 336,
                                  height: 97,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Color(0xFFEFF0F2)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 12,
                                top: 8,
                                child: Container(
                                  width: 78,
                                  height: 78,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFBCC5FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                left: 275,
                                child: Text(
                                  (wishData.productPrice -
                                          (wishData.productPrice *
                                              wishData.discount /
                                              100))
                                      .toStringAsFixed(2),
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                left: 230,
                                child: Text(
                                  wishData.productPrice.toStringAsFixed(2),
                                  style: GoogleFonts.lato(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.lineThrough,
                                      height: 1.3),
                                ),
                              ),
                              Positioned(
                                left: 101,
                                top: 14,
                                child: SizedBox(
                                  width: 162,
                                  child: Text(
                                    wishData.productName,
                                    style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 23,
                                top: 14,
                                child: Image.network(
                                  wishData.imageUrl[0],
                                  width: 58,
                                  height: 67,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                left: 284,
                                top: 47,
                                child: GestureDetector(
                                  onTap: () {
                                    favoriteData.removeItem(wishData.productId);
                                  },
                                  child: Image.asset(
                                    'assets/icons/delete.png',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
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
              ));
  }
}
