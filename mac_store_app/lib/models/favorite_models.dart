class FavoriteModels {
  final String productName;
  final String productId;
  final List imageUrl;

  final double productPrice;
  final int discount;

  FavoriteModels(
      {required this.productName,
      required this.productId,
      required this.imageUrl,
      required this.productPrice,
      required this.discount});
}
