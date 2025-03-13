import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/cart_models.dart';

//Generally accesible for project
final cartProvider =
    StateNotifierProvider<CardNotifier, Map<String, CartModels>>((ref) {
  return CardNotifier();
});

class CardNotifier extends StateNotifier<Map<String, CartModels>> {
  CardNotifier() : super({}); //Initialize empty class

  void addProductToCard(
      {required String productName,
      required int productPrice,
      required String categoryName,
      required List imageUrl,
      required int quantity,
      required int inStock,
      required String productId,
      required String productSize,
      required int discount,
      required String description}) {
    //check if product added already
    if (state.containsKey(productId)) {
      //Update state
      state = {
        //store item
        ...state,
        productId: CartModels(
            productName: state[productId]!.productName,
            productPrice: state[productId]!.productPrice,
            categoryName: state[productId]!.categoryName,
            imageUrl: state[productId]!.imageUrl,
            //ıf already added just increment quantity by one
            quantity: state[productId]!.quantity + 1,
            inStock: state[productId]!.inStock,
            productId: state[productId]!.productId,
            productSize: state[productId]!.productSize,
            discount: state[productId]!.discount,
            description: state[productId]!.description),
      };
    } else {
      //store item
      state = {
        ...state,
        productId: CartModels(
            productName: productName,
            productPrice: productPrice,
            categoryName: categoryName,
            imageUrl: imageUrl,
            quantity: quantity,
            inStock: inStock,
            productId: productId,
            productSize: productSize,
            discount: discount,
            description: description)
      };
    }
  }

  //Function for remove item from cart, carttakilerin hepsi state objectte depolanır
  void removeItem(String productId) {
    state.remove(productId);

    //notify listeners that state has changed
    state = {...state};
  }

  //function for incrementing item on cart
  void incrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;
    }

    //notify listeners that state has changed
    state = {...state};
  }

  //function for decrement item on cart
  void decrementItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;
    }

    //notify listeners that state has changed
    state = {...state};
  }

  //function for calculating total
  double calculateTotalAmount() {
    double totalAmount = 0.0;

    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * cartItem.discount;
    });

    return totalAmount;
  }

  //Retrieve value of object
  Map<String, CartModels> get getCardItem => state;
}
