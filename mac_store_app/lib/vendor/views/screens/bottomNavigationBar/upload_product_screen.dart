import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  bool _isSizeVisible = false;

  //for use ImagePicker
  final ImagePicker imagePicker = ImagePicker();

  //We will store selected images there
  List<File> images = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _sizeController = TextEditingController();

  bool _isEntered = false;
  final List<String> _categoryList = [];

  //This values will be updated to cloud
  List<String> _sizeList = [];
  String? selectedCategory;
  String? productName;
  double? productPrice;
  int? discount;
  int? quantity;
  String? description;

  bool _isLoading = false;

  List<String> imageUrlList = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  chooseImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print("There is no image selected");
    } else {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

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

  //Upload product images to storage
  uploadProductImagesToStorage() async {
    for (var image in images) {
      Reference ref =
          _firebaseStorage.ref().child('productImages').child(Uuid().v4());
      await ref.putFile(image).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            imageUrlList.add(value);
          });
        });
      });
    }
  }

  //Upolad products to cloud function
  uploadData() async {
    setState(() {
      _isLoading = true;
    });
    //document name will be user uid
    DocumentSnapshot vendorDoc = await _firestore
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await uploadProductImagesToStorage();
    if (imageUrlList.isNotEmpty) {
      final productId = Uuid().v4();
      await _firestore.collection('products').doc(productId).set({
        'productId': productId,
        'productName': productName,
        'productPrice': productPrice,
        'productSize': _sizeList,
        'category': selectedCategory,
        'description': description,
        'discount': discount,
        'quantity': quantity,
        'productPrices': [
          {
            'time': Timestamp.now(),
            'price': (productPrice! - (productPrice! * discount! / 100))
          }
        ],
        'productImage': imageUrlList,
        'vendorId': FirebaseAuth.instance.currentUser!.uid,
        'storeName': (vendorDoc.data() as Map<String, dynamic>)['fullname'],
        'rating': 0,
        'totalReviews': 0,
        'isPopular': false,
      }).whenComplete(() {
        setState(() {
          //Clear datas after update
          _isLoading = false;
          _formKey.currentState!.reset();
          imageUrlList.clear();
          images.clear();
        });
      });
    }
  }

  @override
  void initState() {
    _getCatefories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //+1 for add button
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: images.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //3 images on 1 row
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    //check for index 0
                    return index == 0
                        ? Center(
                            child: IconButton(
                                onPressed: () {
                                  chooseImage();
                                },
                                icon: Icon(Icons.add)),
                          )
                        : SizedBox(
                            child: Image.file(images[index - 1]),
                          );
                  }),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
                              if (value.isNotEmpty &&
                                  double.tryParse(value) != null) {
                                productPrice = double.parse(value);
                              } else {
                                //sayı yanlış girilirse ne olacak
                                productPrice = 0.0;
                              }
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
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isNotEmpty && int.tryParse(value) != null) {
                          discount = int.parse(value);
                        } else {
                          //sayı yanlış girilirse ne olacak
                          discount = 0;
                        }
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
                        if (value.isNotEmpty && int.tryParse(value) != null) {
                          quantity = int.parse(value);
                        } else {
                          //sayı yanlış girilirse ne olacak
                          quantity = 1;
                        }
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
                    //on add size if you click size etiket it will be removed
                    Row(
                      children: [
                        Visibility(
                          visible: !_isSizeVisible,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Do you want to add size: "),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSizeVisible = true;
                                    });
                                  },
                                  icon: Icon(Icons.add))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _isSizeVisible,
                          child: Flexible(
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
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade800,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    //first form validation
                    if (_formKey.currentState!.validate()) {
                      uploadData();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : Text(
                              "Upload product",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
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
      items: _categoryList.map((value) {
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
