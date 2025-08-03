part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}

class FetchProductsEvent extends ProductsEvent {
  final bool isInitialLoad;

  FetchProductsEvent({this.isInitialLoad = false});
}
