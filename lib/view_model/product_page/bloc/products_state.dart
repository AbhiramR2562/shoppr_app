part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

class ProductLoading extends ProductsState {}

class ProductLoaded extends ProductsState {
  final List<ProductItem> products;
  final bool hasMore;
  final bool isLoadingMore;
  final List<String> categories;

  ProductLoaded(
    this.products,
    this.hasMore, {
    this.isLoadingMore = false,
    this.categories = const [],
  });
}

class ProductError extends ProductsState {
  final String message;

  ProductError(this.message);
}

class CategoryLoaded extends ProductsState {
  final List<String> categories;

  CategoryLoaded(this.categories);
}
