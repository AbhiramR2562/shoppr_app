part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

class ProductLoading extends ProductsState {}

class ProductLoaded extends ProductsState {
  final List<ProductItem> products;
  final bool hasMore;
  final bool isLoadingMore;

  ProductLoaded(this.products, this.hasMore, {this.isLoadingMore = false});
}

class ProductError extends ProductsState {
  final String message;

  ProductError(this.message);
}

class CategoryLoaded extends ProductsState {
  final List<String> categories;

  CategoryLoaded(this.categories);
}
