part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

// Add to cart
class AddToCartEvent extends CartEvent {
  final ProductItem product;

  AddToCartEvent({required this.product});
}

class RemoveFromCartEvent extends CartEvent {
  final ProductItem product;

  RemoveFromCartEvent(this.product);
}
