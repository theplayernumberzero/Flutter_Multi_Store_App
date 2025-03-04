import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mac_store_app/models/category_models.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //State management (keep track data)(listening for changes and update ui accordingly)
  RxList<CategoryModels> categories = <CategoryModels>[].obs;

  //her CategoryController objesi oluştuğunda _fetchCategories çalışsın
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _fetchCategories();
  }

  //retrieve data from firestore
  void _fetchCategories() {
    //with listen if any change trigger a function
    _firestore
        .collection('categories')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      categories.assignAll(
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return CategoryModels(
              categoryName: data['categoryName'],
              categoryImage: data['categoryImage']);
        }).toList(),
      );
    });
  }
}
