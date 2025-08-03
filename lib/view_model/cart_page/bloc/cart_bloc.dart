import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoppr/data/model/product_items.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<ProductItem> _cartItems = [];
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>(addToCartEvent);
  }

  FutureOr<void> addToCartEvent(AddToCartEvent event, Emitter<CartState> emit) {
    _cartItems.add(event.product);
    emit(CartUpdated(List.from(_cartItems)));
  }
}
