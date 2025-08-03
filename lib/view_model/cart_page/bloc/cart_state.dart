part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartUpdated extends CartState {
  final List<CartItem> cartItems;

  CartUpdated(this.cartItems);
}
