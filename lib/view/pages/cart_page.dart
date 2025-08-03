import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/view/widgets/product_tile.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart page")),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, State) {
          if (State is CartUpdated) {
            final items = State.cartItems;

            if (items.isEmpty) {
              return Center(child: Text("Cart is empty"));
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return ProductTile(product: product, onPressed: () {});
              },
            );
          } else {
            return const Center(child: Text("Loading cart..."));
          }
        },
      ),
    );
  }
}
