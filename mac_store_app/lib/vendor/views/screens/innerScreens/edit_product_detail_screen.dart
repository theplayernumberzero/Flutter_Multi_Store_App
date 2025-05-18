import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mac_store_app/vendor/views/screens/main_vendor_screen.dart';

class EditProductDetailScreen extends StatefulWidget {
  final DocumentSnapshot product;

  const EditProductDetailScreen({super.key, required this.product});

  @override
  State<EditProductDetailScreen> createState() =>
      _EditProductDetailScreenState();
}

class _EditProductDetailScreenState extends State<EditProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;

  bool _isLoading = false;

  @override
  void initState() {
    final data = widget.product.data() as Map<String, dynamic>;

    _nameController = TextEditingController(text: data['productName']);
    _priceController =
        TextEditingController(text: data['productPrice'].toString());
    _discountController =
        TextEditingController(text: data['discount'].toString());
    _quantityController =
        TextEditingController(text: data['quantity'].toString());
    _descriptionController = TextEditingController(text: data['description']);

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Emin misiniz?'),
        content: Text(
            "${_nameController.text} ürününü güncellemek istediğinize emin misiniz?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Hayır")),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text("Evet")),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product.id)
          .update({
        'productName': _nameController.text,
        'productPrice': double.tryParse(_priceController.text) ?? 0.0,
        'discount': int.tryParse(_discountController.text) ?? 0,
        'quantity': int.tryParse(_quantityController.text) ?? 1,
        'description': _descriptionController.text,
      });

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainVendorScreen()),
        (route) => false,
      );

      Future.delayed(Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün güncellendi')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update: " + widget.product['productName'])),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextField(
                  _nameController,
                  'Product Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product name is required';
                    } else if (value.length < 1) {
                      return 'Product name must be at least 1 character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextField(
                  _priceController,
                  'Price',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Please enter a valid price';
                    }
                    if (price < 1) {
                      return 'Price must be at least 1';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextField(
                  _discountController,
                  'Discount',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Discount is required';
                    }
                    final discount = int.tryParse(value);
                    if (discount == null) {
                      return 'Please enter a valid number';
                    }
                    if (discount < 0 || discount > 100) {
                      return 'Discount must be between 0 and 100';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextField(
                  _quantityController,
                  'Quantity',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Quantity is required';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null) {
                      return 'Please enter a valid number';
                    }
                    if (quantity < 1) {
                      return 'Quantity must be at least 1';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextField(
                  _descriptionController,
                  'Description',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    } else if (value.length < 1) {
                      return 'Description must be at least 1 character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateProduct,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Update Product"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String labelText, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
