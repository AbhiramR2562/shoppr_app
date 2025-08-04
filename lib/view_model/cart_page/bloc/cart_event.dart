part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

// Add to cart
class AddToCartEvent extends CartEvent {
  final ProductItem product;
  final int quantity;

  AddToCartEvent({required this.product, required this.quantity});
}

// Remove from cart
class RemoveFromCartEvent extends CartEvent {
  final ProductItem product;

  RemoveFromCartEvent(this.product);
}

// Increase cart item
class IncreaseCartItemEvent extends CartEvent {
  final int productId;
  IncreaseCartItemEvent(this.productId);
}

// Decrease cart item
class DecreaseCartItemEvent extends CartEvent {
  final int productId;
  DecreaseCartItemEvent(this.productId);
}

// clear cart
class ClearCartEvent extends CartEvent {}

// Loading
class CartLoading extends CartState {}
