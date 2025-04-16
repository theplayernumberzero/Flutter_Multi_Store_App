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
          //ctx context objesi
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

      //Bu widget hâlâ aktif mi? Eğer değilse hiçbir şey yapma, çünkü kullanıcı bu sayfadan çıkmış olabilir.
      if (!mounted) return;

      // 👇 Route kullanmadan, doğrudan HomePage'e dön
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainVendorScreen()),
        (route) => false,
      );

      // ScaffoldMessenger için context'i biraz geciktiriyoruz
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
            child: Column(children: [
              buildTextField(_nameController, 'Product Name'),
              SizedBox(height: 16),
              buildTextField(_priceController, 'Price',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16),
              buildTextField(_discountController, 'Discount',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16),
              buildTextField(_quantityController, 'Quantity',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16),
              buildTextField(_descriptionController, 'Description',
                  maxLines: 4),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProduct,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Update Product"),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'Lütfen $labelText girin' : null,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
