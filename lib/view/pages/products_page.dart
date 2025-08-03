import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/data/repositories/product_repository.dart';
import 'package:shoppr/view/pages/product_detail_page.dart';
import 'package:shoppr/view/widgets/product_tile.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';
import 'package:shoppr/view_model/product_page/bloc/products_bloc.dart';
import 'package:shoppr/data/model/product_items.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ProductsBloc _productsBloc;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _productsBloc = ProductsBloc(repository: ProductRepository());
    _productsBloc.add(FetchProductsEvent(isInitialLoad: true));
    _productsBloc.add(FetchCategoriesEvent());

    // Scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore) {
        isLoadingMore = true;
        _productsBloc.add(FetchProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _productsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productsBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(title: Text("Home Page"), centerTitle: true),
        body: BlocListener<ProductsBloc, ProductsState>(
          listener: (context, state) {
            if (state is CategoryLoaded) {
              setState(() {
                _categories = state.categories;
              });
            }
          },
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                isLoadingMore = false; //  Reset loading flag
                // Access products from first ProductModel
                final productList = state.products;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search products',
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search),
                                ),
                                onChanged: (query) {
                                  // handle search here
                                  if (query.trim().isNotEmpty) {
                                    context.read<ProductsBloc>().add(
                                      SearchProductsEvent(query.trim()),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.filter_list),
                          ),
                        ],
                      ),
                    ),
                    if (_categories.isNotEmpty)
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListView.separated(
                          itemCount: _categories.length,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          separatorBuilder: (_, __) => const SizedBox(width: 8),

                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return ElevatedButton(
                              onPressed: () {
                                // Search using the category name
                                context.read<ProductsBloc>().add(
                                  LoadProductByCategoryevent(category),
                                );
                              },
                              child: Text(category),
                            );
                          },
                        ),
                      ),
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: isLoadingMore
                            ? productList.length + 1
                            : productList.length,
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          if (index >= productList.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final product = productList[index];
                          return ProductTile(
                            product: product,
                            onPressed: () {
                              // Go to the product detail page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            // product adding to cart
                            onTap: () {
                              context.read<CartBloc>().add(
                                AddToCartEvent(product: product),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,

                                  content: Text(
                                    '${product.title} added to cart',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    //  Bottom loader for pagination
                    if (state.isLoadingMore)
                      CircularProgressIndicator(strokeWidth: 4),
                  ],
                );
              } else if (state is ProductError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text("No products found."));
              }
            },
          ),
        ),
      ),
    );
  }
}
