import 'package:app_web/views/side_bar_screens/widgets/banner_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String id = "/uploadBannerScreen";
  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<UploadBannerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Store picked image locally
  dynamic _image;
  //Store picked image name locally
  String? fileName;

  //Upload category to firebase storage
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  pickImage() async {
    //Store picked image
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  //Firebase storage foto yükleyip cloud firestore a yüklemek için url ini alma
  _uploadImageToStorage(dynamic image) async {
    Reference ref = _firebaseStorage.ref().child('banners').child(fileName!);
    UploadTask uploadTask = ref.putData(_image);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFirestore() async {
    if (_image != null) {
      EasyLoading.show();
      String imageUrl = await _uploadImageToStorage(_image);
      await _firestore
          .collection('banners')
          .doc(fileName)
          .set({'image': imageUrl})
          .whenComplete(() {
            EasyLoading.dismiss();
            setState(() {
              _image = null;
            });
          });
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      //We can access current state of our form
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "Banners",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      border: Border.all(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child:
                          _image != null
                              ? Image.memory(_image)
                              : Text(
                                'Upload Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        pickImage();
                      },
                      child: Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 30),

              TextButton(
                onPressed: () {
                  uploadToFirestore();
                },
                child: Text('Save'),
              ),
            ],
          ),
          BannerListWidget(),
        ],
      ),
    );
  }
}
