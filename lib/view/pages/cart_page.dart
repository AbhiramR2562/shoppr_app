import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/view/pages/order_success_page%20.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart page"), centerTitle: true),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, State) {
          if (State is CartUpdated) {
            final items = State.cartItems;

            if (items.isEmpty) {
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
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      final product = cartItem.product;
                      final quantity = cartItem.quantity;
                      return ListTile(
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
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                //Add item in to the cart
                                context.read<CartBloc>().add(
                                  IncreaseCartItemEvent(product.id!),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle checkout logic here it will clear the cart item in the cart page
                          context.read<CartBloc>().add(ClearCartEvent());

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text("Checkout successful!"),
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSuccessPage(),
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      ),
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
            return const Center(child: Text("Loading cart..."));
          }
        },
      ),
    );
  }
}
