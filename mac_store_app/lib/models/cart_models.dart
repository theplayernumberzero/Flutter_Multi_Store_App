class CartModels {
  final String productName;
  final double productPrice;
  final String categoryName;
  final List imageUrl;
  int quantity; //total amount buyer wants to but
  final int inStock; //total amount shop have
  final String productId;
  final String productSize;
  final int discount;
  final String description;
  final String vendorId;

  CartModels(
      {required this.productName,
      required this.productPrice,
      required this.categoryName,
      required this.imageUrl,
      required this.quantity,
      required this.inStock,
      required this.productId,
      required this.productSize,
      required this.discount,
      required this.description,
      required this.vendorId});
}
