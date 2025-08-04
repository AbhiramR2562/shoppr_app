import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/data/repositories/product_repository.dart';
import 'package:shoppr/view/pages/product_detail_page.dart';
import 'package:shoppr/view/widgets/product_tile.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';
import 'package:shoppr/view_model/product_page/bloc/products_bloc.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsBloc(repository: ProductRepository())
        ..add(FetchProductsEvent(isInitialLoad: true))
        ..add(FetchCategoriesEvent()),
      child: const ProductsView(),
    );
  }
}

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ScrollController _scrollController = ScrollController();
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final bloc = context.read<ProductsBloc>();
      final state = bloc.state;

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          state is ProductLoaded &&
          !state.isLoadingMore) {
        bloc.add(FetchProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is CategoryLoaded) {
            setState(() {
              _categories = state.categories;
            });
          }
        },
        builder: (context, state) {
          if (state is ProductLoading || state is ProductsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final productList = state.products;

            return productList.isEmpty
                ? const Center(child: Text("No products found."))
                : Column(
                    children: [
                      // Search bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Search products',
                                    border: InputBorder.none,
                                    icon: Icon(Icons.search),
                                  ),
                                  onChanged: (query) {
                                    if (query.trim().isNotEmpty) {
                                      context.read<ProductsBloc>().add(
                                        SearchProductsEvent(query.trim()),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Categories
                      if (_categories.isNotEmpty)
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListView.separated(
                            itemCount: _categories.length,
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              return ElevatedButton(
                                onPressed: () {
                                  context.read<ProductsBloc>().add(
                                    LoadProductByCategoryevent(category),
                                  );
                                },
                                child: Text(category),
                              );
                            },
                          ),
                        ),

                      // Product Grid
                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          itemCount: state.isLoadingMore
                              ? productList.length + 1
                              : productList.length,
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            if (index >= productList.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final product = productList[index];
                            return ProductTile(
                              product: product,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailPage(product: product),

                                    // BlocProvider.value(value: context.read<ProductsBloc>(),
                                    // child: ProductDetailPage(product: product),)
                                  ),
                                );
                              },
                              onTap: () {
                                context.read<CartBloc>().add(
                                  AddToCartEvent(product: product, quantity: 1),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      '${product.title} added to cart',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      if (state.isLoadingMore)
                        // Pagination
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 4),
                        ),
                    ],
                  );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
