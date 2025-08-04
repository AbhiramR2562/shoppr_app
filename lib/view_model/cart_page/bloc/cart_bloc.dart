import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shoppr/data/model/cart_item_model.dart';
import 'package:shoppr/data/model/product_items.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _cartItems = [];
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>(addToCartEvent);
    on<RemoveFromCartEvent>(removeFromCartEvent);
    on<IncreaseCartItemEvent>(increaseCartItemEvent);
    on<DecreaseCartItemEvent>(decreaseCartItemEvent);
    on<ClearCartEvent>(clearCartEvent);
  }

  // Add to cart
  FutureOr<void> addToCartEvent(AddToCartEvent event, Emitter<CartState> emit) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );
    if (index != -1) {
      _cartItems[index].quantity += event.quantity;
    } else {
      _cartItems.add(
        CartItem(product: event.product, quantity: event.quantity),
      );
    }
    emit(CartUpdated(List.from(_cartItems)));
  }

  // Remove from cart
  FutureOr<void> removeFromCartEvent(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) {
    _cartItems.removeWhere((item) => item.product.id == event.product.id);
    emit(CartUpdated(List.from(_cartItems)));
  }

  // Increse cart item
  FutureOr<void> increaseCartItemEvent(
    IncreaseCartItemEvent event,
    Emitter<CartState> emit,
  ) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == event.productId,
    );
    if (index != -1) {
      _cartItems[index].quantity += 1;
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  // Decrease cart item
  FutureOr<void> decreaseCartItemEvent(
    DecreaseCartItemEvent event,
    Emitter<CartState> emit,
  ) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == event.productId,
    );
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        _cartItems.removeAt(index);
      }
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  // Clear cart
  FutureOr<void> clearCartEvent(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    await Future.delayed(
      Duration(milliseconds: 300),
    ); // simulate delay (if needed)
    _cartItems.clear();
    log("Cart cleared, length: ${_cartItems.length}"); // Debug

    emit(CartUpdated(List.from(_cartItems)));
  }
}
