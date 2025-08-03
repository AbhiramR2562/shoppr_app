import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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

  FutureOr<void> addToCartEvent(AddToCartEvent event, Emitter<CartState> emit) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );
    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(CartItem(product: event.product, quantity: 1));
    }
    emit(CartUpdated(List.from(_cartItems)));
  }

  FutureOr<void> removeFromCartEvent(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) {
    _cartItems.removeWhere((item) => item.product.id == event.product.id);
    emit(CartUpdated(List.from(_cartItems)));
  }

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

  FutureOr<void> clearCartEvent(ClearCartEvent event, Emitter<CartState> emit) {
    _cartItems.clear();
    print("Cart cleared, length: ${_cartItems.length}"); // Debug
    emit(CartUpdated(List.from(_cartItems)));
  }
}
