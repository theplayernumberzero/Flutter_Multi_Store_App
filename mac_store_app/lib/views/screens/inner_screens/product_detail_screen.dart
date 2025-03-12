import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Product Detail",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ))
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 260,
              height: 274,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 50,
                    child: Container(
                      width: 260,
                      height: 260,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Color(0xFFD8DDFF),
                          borderRadius: BorderRadius.circular(130)),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 0,
                    child: Container(
                      width: 216,
                      height: 274,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          color: Color(0xFF9CA8FF),
                          borderRadius: BorderRadius.circular(14)),
                      child: SizedBox(
                        height: 300,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productData['productImage'].length,
                          itemBuilder: (context, index) {
                            return Image.network(
                                width: 198,
                                height: 225,
                                fit: BoxFit.cover,
                                productData['productImage'][index]);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productData['productName'],
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                Text(
                  "\$${productData['productPrice'].toStringAsFixed(2)}",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.deepPurpleAccent,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              productData['category'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Size: ",
                  style: GoogleFonts.lato(
                    color: Color(0xFF343434),
                    fontSize: 16,
                    letterSpacing: 1.6,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: productData['productSize'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF126881),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                productData['productSize'][index],
                                style: GoogleFonts.lato(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.lato(
                    color: Color(0xFF363330),
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                Text(productData['description'])
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 386,
            height: 48,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(24)),
            child: Center(
              child: Text(
                "ADD TO CARD",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
