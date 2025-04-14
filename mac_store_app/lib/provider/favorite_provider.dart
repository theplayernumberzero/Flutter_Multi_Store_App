import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/favorite_models.dart';

//In order to make it generally accessible
final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModels>>((ref) {
  return FavoriteNotifier(); //instance, now we have access in all app
});

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModels>> {
  //StateNotifier keep track FavoriteNotifier and what type of value you waiting
  FavoriteNotifier() : super({}); //initialize class

  //for add product to fav
  void addProductToFavorite(
      {required String productName,
      required String productId,
      required List imageUrl,
      required double productPrice}) {
    state[productId] = FavoriteModels(
        productName: productName,
        productId: productId,
        imageUrl: imageUrl,
        productPrice: productPrice);

    //notify listeners that states has changed

    state = {...state};
  }

  void removeAllItem() {
    state.clear();

    //notify listeners that states has changed
    state = {...state};
  }

  void removeItem(String productId) {
    state.remove(productId);

    //notify listeners that states has changed
    state = {...state};
  }

  //retrieve value from state object
  Map<String, FavoriteModels> get getFavoriteItem => state;
}
