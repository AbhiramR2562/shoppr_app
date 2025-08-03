import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shoppr/data/model/product_items.dart';
import 'package:shoppr/data/repositories/product_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository repository;

  List<ProductItem> _allProducts = [];

  List<String> _categories = [];

  int _skip = 0;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isFetching = false;

  ProductsBloc({required this.repository}) : super(ProductsInitial()) {
    on<FetchProductsEvent>(fetchProducts);
    on<SearchProductsEvent>(searchProductsEvent);
    on<FetchCategoriesEvent>(fetchCategoriesEvent);
    on<LoadProductByCategoryevent>(loadProductByCategoryevent);
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

  FutureOr<void> searchProductsEvent(
    SearchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final result = await repository.searchProducts(event.query);
      emit(ProductLoaded(result.products ?? [], result.products.length < 10));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  FutureOr<void> fetchCategoriesEvent(
    FetchCategoriesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      _categories = await repository.getCategories();
      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(ProductError('Failed to fetch categories: $e'));
    }
  }

  FutureOr<void> loadProductByCategoryevent(
    LoadProductByCategoryevent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(ProductLoading());
      final categoryProducts = await repository.getProductByCategory(
        event.category,
      );
      _allProducts = categoryProducts.products ?? [];
      _hasMore = false;
      emit(ProductLoaded(List.from(_allProducts), _hasMore));
    } catch (e) {
      emit(ProductError('Failed to load category products: $e'));
    }
  }
}
