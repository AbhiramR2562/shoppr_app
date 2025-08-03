part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartUpdated extends CartState {
  final List<ProductItem> cartItems;

  CartUpdated(this.cartItems);
}
