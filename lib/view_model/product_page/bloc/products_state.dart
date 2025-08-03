part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

class ProductLoading extends ProductsState {}

class ProductLoaded extends ProductsState {
  final List<ProductItem> products;
  final bool hasMore;

  ProductLoaded(this.products, this.hasMore);
}

class ProductError extends ProductsState {
  final String message;

  ProductError(this.message);
}
