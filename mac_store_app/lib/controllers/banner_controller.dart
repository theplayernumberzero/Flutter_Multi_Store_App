import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getBannerUrls() {
    //Snapshots listing data under banner collection (listen changes in collection)
    return _firestore.collection('banners').snapshots().map((snapshot) {
      //In docs enter field which you want to extract
      return snapshot.docs.map((doc) => doc['image'] as String).toList();
    });
  }
}
