import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/views/screens/inner_screens/product_detail_screen.dart';

class ProducutItemWidget extends StatelessWidget {
  final dynamic productData;

  const ProducutItemWidget({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      productData: productData,
                    )));
      },
      child: Container(
        width: 146,
        height: 245,
        clipBehavior:
            Clip.antiAlias, //In order to use it we need to use decoration
        decoration: BoxDecoration(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 146,
                height: 245,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      spreadRadius: 0,
                      offset: Offset(0, 18),
                      blurRadius: 30)
                ], color: Colors.white, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Positioned(
              left: 8,
              top: 130,
              child: Text(
                productData['productName'],
                style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3),
              ),
            ),
            Positioned(
              left: 8,
              top: 177,
              child: Text(
                productData['category'],
                style: GoogleFonts.lato(fontSize: 12, letterSpacing: 0.2),
              ),
            ),
            Positioned(
              left: 8,
              top: 207,
              child: Text(
                '\$${productData['productPrice'] - (productData['productPrice'] * productData['discount'] / 100)}',
                style: GoogleFonts.lato(
                    fontSize: 20,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w600),
              ),
            ),
            //previous price
            Positioned(
              left: 80,
              top: 210,
              child: Text(
                '\$${productData['productPrice']}',
                style: GoogleFonts.lato(
                    color: Colors.grey,
                    fontSize: 16,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough),
              ),
            ),
            Positioned(
              left: 9,
              top: 9,
              child: Container(
                width: 128,
                height: 108,
                clipBehavior: Clip.antiAlias, //Smooth edges
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -1,
                      top: -1,
                      child: Container(
                        width: 130,
                        height: 110,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFF5C3),
                            border: Border.all(width: 0.8, color: Colors.white),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 4,
                      child: Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: -10,
                      //Retrieve image and save it locally
                      child: CachedNetworkImage(
                          width: 108,
                          height: 107,
                          imageUrl: productData['productImage'][0]),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 56,
              top: 155,
              child: Text(
                productData['quantity'] != 0
                    ? "Last ${productData['quantity']}"
                    : "Sold out",
                style: TextStyle(color: Colors.blueGrey, fontSize: 12),
              ),
            ),
            productData['rating'] == 0
                ? const SizedBox()
                : Positioned(
                    left: 8,
                    top: 158,
                    child: Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                      size: 12,
                    )),
            Positioned(
              left: 23,
              top: 155,
              child: Text(
                productData['rating'] == 0
                    ? ""
                    : productData['rating'].toString(),
                style: GoogleFonts.lato(color: Colors.blueGrey, fontSize: 12),
              ),
            ),
            // Positioned(
            //   left: 104,
            //   top: 15,
            //   child: Container(
            //     width: 28,
            //     height: 28,
            //     decoration: BoxDecoration(
            //         color: Colors.orange,
            //         borderRadius: BorderRadius.circular(16),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.red,
            //               spreadRadius: 0,
            //               offset: Offset(0, 7),
            //               blurRadius: 16)
            //         ]),
            //   ),
            // ),
            // Positioned(
            //   right: 5,
            //   top: 5,
            //   child: IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         Icons.favorite_border,
            //         color: Colors.white,
            //         size: 16,
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
