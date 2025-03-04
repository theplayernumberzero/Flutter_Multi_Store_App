import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/controllers/banner_controller.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerController _bannerController = BannerController();
  @override
  Widget build(BuildContext context) {
    //you can scroll left to right because of PageView
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(color: Color(0xFFF7F7F7), boxShadow: [
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0, 2)),
        ]),
        child: StreamBuilder<List<String>>(
            //Location of data we want to stream
            stream: _bannerController.getBannerUrls(),
            //How we indetend to render each banners
            builder: (context, snapshot) {
              //Snapshot means current data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              } else if (snapshot.hasError) {
                return (Icon(Icons.error));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Banners avaiable",
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            //store banner locally
                            imageUrl: snapshot.data![index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          );
                        }),
                    _indicatorBuild(snapshot.data!.length)
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget _indicatorBuild(int pageCount) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration:
                BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          );
        }),
      ),
    );
  }
}

//get data from firebase database (retrieve banners from cloud firestore)
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //final List _bannerImage = [];

  //Without getx widget
  // getBanners() {
  //   return _firestore
  //       .collection("banners")
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       //Bannerstaki kayıtlı doc alındı
  //       _bannerImage
  //           .add(doc['image']); //kayıtlı doc un image proproetysine erişildi
  //     });
  //     setState(() {});
  //   });
  // }

  //Widget yüklendiği gibi func çalışsın
  // @override
  // void initState() {
  //   getBanners();
  //   super.initState();
  // }

//you can scroll left to right because of PageView
// return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: 140,
//       //display more than one item
//       //itembuilder: How we intend to display each item
//       child: PageView.builder(
//           itemCount: _bannerImage.length,
//           itemBuilder: (context, index) {
//             return Image.network(_bannerImage[index]);
//           }),
//     );

// Image.network(
//                             snapshot.data![index],
//                             fit: BoxFit.cover,
//                           );