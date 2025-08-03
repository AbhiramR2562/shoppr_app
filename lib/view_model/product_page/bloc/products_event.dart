part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class FetchProductsEvent extends ProductsEvent {
  final bool isInitialLoad;

  FetchProductsEvent({this.isInitialLoad = false});
}

class SearchProductsEvent extends ProductsEvent {
  final String query;

  SearchProductsEvent(this.query);
}

class FetchCategoriesEvent extends ProductsEvent {}

class FilterByCategoryEvent extends ProductsEvent {
  final String category;
  FilterByCategoryEvent(this.category);
}

class LoadProductByCategoryevent extends ProductsEvent {
  final String category;
  LoadProductByCategoryevent(this.category);
}
