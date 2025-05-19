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

  // TextEditingController'ları ekleyelim
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  late String state;
  late String city;
  late String locality;
  late String pinCode;

  @override
  void initState() {
    super.initState();
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    try {
      final DocumentSnapshot userData = await _firestore
          .collection('buyers')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userData.exists) {
        setState(() {
          // Controller'ları güncelle
          _stateController.text = userData.get('state') ?? '';
          _cityController.text = userData.get('city') ?? '';
          _localityController.text = userData.get('locality') ?? '';
          _pinCodeController.text = userData.get('pincode') ?? '';

          // String değişkenlerini güncelle
          state = userData.get('state') ?? '';
          city = userData.get('city') ?? '';
          locality = userData.get('locality') ?? '';
          pinCode = userData.get('pincode') ?? '';
        });
      }
    } catch (e) {
      print('Adres bilgileri yüklenirken hata: $e');
    }
  }

  @override
  void dispose() {
    _stateController.dispose();
    _cityController.dispose();
    _localityController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

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
                  controller: _stateController,
                  onChanged: (value) {
                    state = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Eyalet/Bölge boş bırakılamaz";
                    }
                    if (value.trim().length < 2) {
                      return "Eyalet/Bölge en az 2 karakter olmalıdır";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "State",
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _cityController,
                  onChanged: (value) {
                    city = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Şehir boş bırakılamaz";
                    }
                    if (value.trim().length < 2) {
                      return "Şehir adı en az 2 karakter olmalıdır";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "City",
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _localityController,
                  onChanged: (value) {
                    locality = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Mahalle/Semt boş bırakılamaz";
                    }
                    if (value.trim().length < 3) {
                      return "Mahalle/Semt en az 3 karakter olmalıdır";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Locality",
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _pinCodeController,
                  onChanged: (value) {
                    pinCode = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Posta kodu boş bırakılamaz";
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Posta kodu sadece rakam içermelidir";
                    }
                    if (value.length != 5) {
                      return "Posta kodu 5 haneli olmalıdır";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Pin code",
                    errorStyle: TextStyle(color: Colors.red),
                  ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lütfen tüm alanları doğru şekilde doldurun'),
                  backgroundColor: Colors.red,
                ),
              );
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Updating Address"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text("Please wait.."),
            ],
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}
