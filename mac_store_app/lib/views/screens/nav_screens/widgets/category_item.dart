import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/category_controller.dart';
import 'package:mac_store_app/views/screens/inner_screens/category_product_screen.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  final CategoryController _categoryController = Get.find<CategoryController>();
  @override
  Widget build(BuildContext context) {
    //Obx ile state de bir güncelleme olduğunda buraya da güncelleme yapar (when you have new data it will updat immaidetly)
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _categoryController.categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 4, crossAxisSpacing: 8, crossAxisCount: 4),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryProductScreen(
                                categoryModel:
                                    _categoryController.categories[index])));
                  },
                  child: Column(
                    children: [
                      Image.network(
                        _categoryController.categories[index].categoryImage,
                        width: 47,
                        height: 47,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        _categoryController.categories[index].categoryName,
                        style: GoogleFonts.quicksand(
                            fontSize: 14,
                            letterSpacing: 0.3,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              })
        ],
      );
    });
  }
}
