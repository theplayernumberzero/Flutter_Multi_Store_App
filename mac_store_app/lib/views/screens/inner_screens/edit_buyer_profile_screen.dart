import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

class EditBuyerProfileScreen extends StatefulWidget {
  const EditBuyerProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditBuyerProfileScreen> createState() => _EditBuyerProfileScreenState();
}

class _EditBuyerProfileScreenState extends State<EditBuyerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController _fullnameController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _localityController;
  late TextEditingController _pincodeController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
    _stateController = TextEditingController();
    _cityController = TextEditingController();
    _localityController = TextEditingController();
    _pincodeController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _firestore
          .collection('buyers')
          .doc(_auth.currentUser!.uid)
          .get();

      if (userData.exists) {
        setState(() {
          _fullnameController.text = userData.get('fullname') ?? '';
          _stateController.text = userData.get('state') ?? '';
          _cityController.text = userData.get('city') ?? '';
          _localityController.text = userData.get('locality') ?? '';
          _pincodeController.text = userData.get('pincode') ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading user data')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('buyers').doc(_auth.currentUser!.uid).update({
        'fullname': _fullnameController.text.trim(),
        'state': _stateController.text.trim(),
        'city': _cityController.text.trim(),
        'locality': _localityController.text.trim(),
        'pincode': _pincodeController.text.trim(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _localityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fullnameController,
                  decoration: _buildInputDecoration('Full Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Full name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stateController,
                  decoration: _buildInputDecoration('State'),
                  validator: (value) =>
                      value!.isEmpty ? 'State is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: _buildInputDecoration('City'),
                  validator: (value) =>
                      value!.isEmpty ? 'City is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _localityController,
                  decoration: _buildInputDecoration('Locality'),
                  validator: (value) =>
                      value!.isEmpty ? 'Locality is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pincodeController,
                  decoration: _buildInputDecoration('Pincode'),
                  validator: (value) =>
                      value!.isEmpty ? 'Pincode is required' : null,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Apply Changes',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}
