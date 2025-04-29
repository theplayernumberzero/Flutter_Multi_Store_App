import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  Uint8List? _profileImage;

  //function for update profile picture
  pickProfileImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    } else {
      print("There is no image selected by user");
    }
  }

  //Galeriden resim seçmemizi sağlar
  selectGaleryImage() async {
    Uint8List image = await pickProfileImage(ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit your profile"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Fullname"),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                decoration:
                    InputDecoration(labelText: "New profile picture url"),
              )),
              IconButton(
                  onPressed: () {
                    selectGaleryImage();
                  },
                  icon: Icon(Icons.image))
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel")),
        TextButton(onPressed: () {}, child: Text("Save"))
      ],
    );
  }
}
