import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  //get data from firebase database (retrieve banners from cloud firestore)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List _bannerImage = [];

  getBanners() {
    return _firestore
        .collection("banners")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //Bannerstaki kayıtlı doc alındı
        _bannerImage
            .add(doc['image']); //kayıtlı doc un image proproetysine erişildi
      });
      setState(() {});
    });
  }

  //Widget yüklendiği gibi func çalışsın
  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //you can scroll left to right because of PageView
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 140,
      //display more than one item
      //itembuilder: How we intend to display each item
      child: PageView.builder(
          itemCount: _bannerImage.length,
          itemBuilder: (context, index) {
            return Image.network(_bannerImage[index]);
          }),
    );
  }
}
