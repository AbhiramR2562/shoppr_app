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

  // Store all products fetched
  List<ProductItem> _allProducts = [];

  // Store product categories
  List<String> _categories = [];

  // Pagination controls
  int _skip = 0;
  final int _limit = 10;
  // Is there more data to load?
  bool _hasMore = true;
  // Prevent multiple fetches at once
  bool _isFetching = false;

  ProductsBloc({required this.repository}) : super(ProductsInitial()) {
    on<FetchProductsEvent>(fetchProducts);
    on<SearchProductsEvent>(searchProductsEvent);
    on<FetchCategoriesEvent>(fetchCategoriesEvent);
    on<LoadProductByCategoryevent>(loadProductByCategoryevent);
  }

  // Handler to fetch all products with pagination
  FutureOr<void> fetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    print(
      "----------Emitting ProductLoaded with ${_allProducts.length} products",
    );
    // Stop fetching if already fetching or no more data to load
    if (_isFetching || (!_hasMore && !event.isInitialLoad)) return;

    _isFetching = true;

    if (event.isInitialLoad) {
      // First time loading: show loading spinner and reset values
      emit(ProductLoading());
      _allProducts.clear();
      _skip = 0;
      _hasMore = true;
    } else {
      // For loading more: keep previous data and show loading indicator
      emit(
        ProductLoaded(List.from(_allProducts), _hasMore, isLoadingMore: true),
      );
    }

    try {
      // Fetch new products
      final fetchedProducts = await repository.getAllProducts(
        limit: _limit,
        skip: _skip,
      );

      final newProducts = fetchedProducts.products;

      // Check if more products are available
      if (newProducts.isEmpty || newProducts.length < _limit) {
        _hasMore = false;
      }

      // Add new data to the  list
      _allProducts.addAll(newProducts);
      // Update the skip count
      _skip += _limit;

      //  Emit loaded state with updated data
      emit(ProductLoaded(List.from(_allProducts), _hasMore));
    } catch (e) {
      // Emit error state if something goes wrong
      emit(ProductError('Failed to load products: $e'));
    } finally {
      // Allow next fetch
      _isFetching = false;
    }
  }

  // Handler for product search
  FutureOr<void> searchProductsEvent(
    SearchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final result = await repository.searchProducts(event.query);
      emit(ProductLoaded(result.products, result.products.length < 10));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  FutureOr<void> fetchCategoriesEvent(
    FetchCategoriesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      final categories = await repository.getCategories();
      _categories.clear();
      _categories.addAll(categories);
      emit(CategoryLoaded(List.from(_categories)));
    } catch (e) {
      emit(ProductError('Failed to fetch categories: $e'));
    }
  }

  // Handler to load products by selected category
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
