import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String state;
  late String city;
  late String locality;
  late String pinCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Delivery",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Where is your address",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
                TextFormField(
                  onChanged: (value) {
                    state = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter State";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(hintText: "State"),
                ),
                SizedBox(
                  height: 32,
                ),
                TextFormField(
                  onChanged: (value) {
                    city = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter City";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(hintText: "City"),
                ),
                SizedBox(
                  height: 32,
                ),
                TextFormField(
                  onChanged: (value) {
                    locality = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Locality";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(hintText: "Locality"),
                ),
                SizedBox(
                  height: 32,
                ),
                TextFormField(
                  onChanged: (value) {
                    pinCode = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Pin Code";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Pin code"),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              //update address info of user
              _showDialog(context);
              await _firestore
                  .collection('buyers')
                  .doc(_auth.currentUser!.uid)
                  .update({
                'state': state,
                'city': city,
                'locality': locality,
                'pincode': pinCode
              }).whenComplete(() {
                Navigator.of(context).pop();
              });
            } else {
              //show snackbar of error
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "ADD ADDRESS",
                style: GoogleFonts.lato(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, //user cant avoided
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Updating Address"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 12,
                ),
                Text("Please wait..")
              ],
            ),
          );
        });

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }
}
