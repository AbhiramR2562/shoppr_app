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

class IncreaseCartItemEvent extends CartEvent {
  final int productId;
  IncreaseCartItemEvent(this.productId);
}

class DecreaseCartItemEvent extends CartEvent {
  final int productId;
  DecreaseCartItemEvent(this.productId);
}

class ClearCartEvent extends CartEvent {}
