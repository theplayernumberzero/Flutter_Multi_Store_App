import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductsScreen extends StatefulWidget {
  static const String id = "/products-screen";
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categoryList = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _getCatefories() {
    _firestore.collection('categories').get().then((
      QuerySnapshot querySnapshot,
    ) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      }
    });
  }

  List<Uint8List> _images = [];
  List<String> _imagesUrls = [];

  chooseImages() async {
    final pickedImages = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (pickedImages != null) {
      setState(() {
        for (var file in pickedImages.files) {
          _images.add(file.bytes!);
        }
      });
    }
  }

  bool _isEntered = false;
  final TextEditingController _sizeController = TextEditingController();

  //This values will be updated to cloud
  List<String> _sizeList = [];
  String? selectedCategory;
  String? productName;
  double? productPrice;
  int? discount;
  int? quantity;
  String? description;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  bool _isLoading = false;

  //Upload product images to storage
  uploadImageToStorage() async {
    for (var image in _images) {
      Reference ref = _firebaseStorage
          .ref()
          .child('productImages')
          .child(Uuid().v4());
      await ref.putData(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            _imagesUrls.add(value);
          });
        });
      });
    }
  }

  @override
  void initState() {
    _getCatefories();
    super.initState();
  }

  //Upolad products to cloud function
  uploadData() async {
    setState(() {
      _isLoading = true;
    });
    await uploadImageToStorage();
    if (_imagesUrls.isNotEmpty) {
      final productId = Uuid().v4();
      await _firestore
          .collection('products')
          .doc(productId)
          .set({
            'productId': productId,
            'productName': productName,
            'productPrice': productPrice,
            'productSize': _sizeList,
            'category': selectedCategory,
            'description': description,
            'discount': discount,
            'quantity': quantity,
            'productImage': _imagesUrls,
          })
          .whenComplete(() {
            setState(() {
              //Clear datas after update
              _isLoading = false;
              _formKey.currentState!.reset();
              _imagesUrls.clear();
              _images.clear();
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Product Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                onChanged: (value) {
                  productName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter product name";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Name',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        productPrice = double.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter price";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Price',
                        fillColor: Colors.grey,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(child: buildDropDownMenu()),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  discount = int.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter discount";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Discount',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  discount = int.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter quantity";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  description = value;
                },
                maxLength: 800,
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter description";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _sizeController,
                        onChanged: (value) {
                          setState(() {
                            _isEntered = true;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Add Size',
                          fillColor: Colors.grey,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  _isEntered == true
                      ? Flexible(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _sizeList.add(_sizeController.text);
                              _sizeController.clear();
                            });
                          },
                          child: Text("Add"),
                        ),
                      )
                      : const Text(""),
                ],
              ),

              _sizeList.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sizeList.length,
                        itemBuilder: (context, index) {
                          //Tıklandığı zaman listten çıkarılacak
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _sizeList.removeAt(index);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade800,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    _sizeList[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  : Text(''),
              SizedBox(height: 20),

              GridView.builder(
                itemCount: _images.length + 1,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                        child: IconButton(
                          onPressed: () {
                            chooseImages();
                          },
                          icon: Icon(Icons.add),
                        ),
                      )
                      : Image.memory(_images[index - 1]);
                },
              ),

              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    //Upload product to cloud firestore
                    uploadData();
                  } else {
                    //Tüm alanları doldur
                    print("Bad status");
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Upload Product",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropDownMenu() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Select Category',
        fillColor: Colors.grey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      items:
          _categoryList.map((value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          selectedCategory = value;
        }
      },
    );
  }
}
