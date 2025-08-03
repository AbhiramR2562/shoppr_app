import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shoppr/data/model/product_items.dart';
import 'package:shoppr/data/repositories/product_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository repository;

  List<ProductItem> _allProducts = [];
  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isFetching = false;

  ProductsBloc({required this.repository}) : super(ProductsInitial()) {
    on<FetchProductsEvent>(fetchProducts);
  }

  FutureOr<void> fetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (_isFetching || (!_hasMore && !event.isInitialLoad)) return;

    _isFetching = true;

    if (event.isInitialLoad) {
      emit(ProductLoading());
      _allProducts.clear();
      _skip = 0;
      _hasMore = true;
    } else {
      // Emit current data with isLoadingMore = true
      emit(
        ProductLoaded(List.from(_allProducts), _hasMore, isLoadingMore: true),
      );
    }

    try {
      final fetchedProducts = await repository.getAllProducts(
        limit: _limit,
        skip: _skip,
      );

      final newProducts = fetchedProducts.products;

      if (newProducts.isEmpty || newProducts.length < _limit) {
        _hasMore = false;
      }

      _allProducts.addAll(newProducts);
      _skip += _limit;

      emit(ProductLoaded(List.from(_allProducts), _hasMore));
    } catch (e) {
      emit(ProductError('Failed to load products: $e'));
    } finally {
      _isFetching = false;
    }
  }
}
