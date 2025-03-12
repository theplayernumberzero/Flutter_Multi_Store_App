class CardModels {
  final String productName;
  final int productPrice;
  final String categoryName;
  final List imageUrl;
  final int quantity; //total amount buyer wants to but
  final int inStock; //total amount shop have
  final String productId;
  final String productSize;
  final int discount;
  final String description;

  CardModels(
      {required this.productName,
      required this.productPrice,
      required this.categoryName,
      required this.imageUrl,
      required this.quantity,
      required this.inStock,
      required this.productId,
      required this.productSize,
      required this.discount,
      required this.description});
}
