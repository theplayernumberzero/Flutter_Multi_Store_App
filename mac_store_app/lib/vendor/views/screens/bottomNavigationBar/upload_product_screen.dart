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
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024, // Resim genişliğini sınırla
        maxHeight: 1024, // Resim yüksekliğini sınırla
        imageQuality: 70, // Resim kalitesini düşür (0-100 arası)
      );

      if (pickedFile == null) {
        print("No image selected");
        return;
      }

      setState(() {
        images.add(File(pickedFile.path));
      });
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error selecting image')));
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
    try {
      if (images.isEmpty) {
        throw Exception('Please select at least one image');
      }

      for (var image in images) {
        // Benzersiz bir dosya adı oluştur
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Storage referansını oluştur
        Reference ref =
            _firebaseStorage.ref().child('productImages').child(fileName);

        // Dosya boyutunu kontrol et ve gerekirse sıkıştır
        final File compressedFile = File(image.path);

        // Upload task oluştur
        final UploadTask uploadTask = ref.putFile(
          compressedFile,
          SettableMetadata(
              contentType: 'image/jpeg',
              customMetadata: {'picked-file-path': image.path}),
        );

        // Upload durumunu takip et
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          print(
              'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        });

        // Upload'ı tamamla
        final TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() => null);
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          imageUrlList.add(downloadUrl);
        });
      }
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: ${e.message}')));
      throw e;
    } catch (e) {
      print('Error uploading images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while uploading images')));
      throw e;
    }
  }

  //Upolad products to cloud function
  uploadData() async {
    try {
      if (images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select at least one image')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Vendor bilgisini al
      DocumentSnapshot vendorDoc = await _firestore
          .collection('vendors')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Resimleri yükle
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
        });

        // Başarılı mesajı göster
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product uploaded successfully')));

        // Form ve state'i temizle
        setState(() {
          _isLoading = false;
          _formKey.currentState!.reset();
          imageUrlList.clear();
          images.clear();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading product: ${e.toString()}')));
      print('Error in uploadData: $e');
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
                          return "Product name is required";
                        } else if (value.length < 1) {
                          return "Product name must be at least 1 character";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Product Name',
                        fillColor: Colors.grey,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
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
                                productPrice = 0.0;
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Price is required";
                              }
                              final price = double.tryParse(value);
                              if (price == null) {
                                return "Please enter a valid price";
                              }
                              if (price < 1) {
                                return "Price must be at least 1";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter Price',
                              fillColor: Colors.grey,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red),
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
                          discount = 0;
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Discount is required";
                        }
                        final discountValue = int.tryParse(value);
                        if (discountValue == null) {
                          return "Please enter a valid number";
                        }
                        if (discountValue < 0 || discountValue > 100) {
                          return "Discount must be between 0 and 100";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Discount',
                        fillColor: Colors.grey,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        if (value.isNotEmpty && int.tryParse(value) != null) {
                          quantity = int.parse(value);
                        } else {
                          quantity = 1;
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Quantity is required";
                        }
                        final quantityValue = int.tryParse(value);
                        if (quantityValue == null) {
                          return "Please enter a valid number";
                        }
                        if (quantityValue < 1) {
                          return "Quantity must be at least 1";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        fillColor: Colors.grey,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
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
                          return "Description is required";
                        } else if (value.length < 1) {
                          return "Description must be at least 1 character";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Description',
                        fillColor: Colors.grey,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null) {
          return "Please select a category";
        }
        return null;
      },
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
