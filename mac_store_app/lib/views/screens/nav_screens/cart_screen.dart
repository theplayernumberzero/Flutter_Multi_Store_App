import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/provider/card_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    //rebuild if there is a change
    final cardData = ref.watch(cardProvider);
    return Scaffold(
        body: ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: cardData.length,
      itemBuilder: (context, index) {
        final cardItem = cardData.values.toList()[index];

        return Center(child: Text(cardItem.productName));
      },
    ));
  }
}
