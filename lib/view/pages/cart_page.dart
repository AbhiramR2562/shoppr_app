import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/view/pages/order_success_page%20.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Cart page"),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(color: Colors.grey[400]),
              ),
            );
          } else if (state is CartUpdated) {
            // Get list of cart items
            final items = state.cartItems;

            if (items.isEmpty) {
              // If cart is empty, show a message
              return Center(
                child: Text(
                  "Cart is empty",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              );
            }

            // Calculate total price
            double totalPrice = 0;
            for (var item in items) {
              totalPrice += (item.product.price ?? 0) * item.quantity;
            }

            return Column(
              children: [
                // List of items in the cart
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      final product = cartItem.product;
                      final quantity = cartItem.quantity;
                      return ListTile(
                        // Product image
                        leading: Image.network(
                          product.thumbnail ?? '',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text("${product.title}"),
                        subtitle: Text("\$${product.price} x $quantity"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Button to decrease quantity
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // Remove the item from the cart
                                context.read<CartBloc>().add(
                                  DecreaseCartItemEvent(product.id!),
                                );
                              },
                            ),
                            // Button to increase quantity
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                //Add item in to the cart
                                context.read<CartBloc>().add(
                                  AddToCartEvent(product: product, quantity: 1),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom section: Checkout button and total price
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // clear All
                      ElevatedButton(
                        onPressed: () {
                          // Clear cart on checkout
                          context.read<CartBloc>().add(ClearCartEvent());
                        },
                        child: const Text('Clear All'),
                      ),

                      // Checkout button
                      Material(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            splashColor: Colors.white.withOpacity(0.3),
                            onTap: () {
                              // Clear cart on checkout
                              context.read<CartBloc>().add(ClearCartEvent());

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderSuccessPage(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.3,
                              alignment: Alignment.center,
                              child: Text(
                                "Check Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Display total price
                      Text(
                        "Total: \$${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Loading....."));
          }
        },
      ),
    );
  }
}
