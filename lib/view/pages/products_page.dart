import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppr/data/repositories/product_repository.dart';
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

  @override
  void initState() {
    super.initState();
    _productsBloc = ProductsBloc(repository: ProductRepository());
    _productsBloc.add(FetchProductsEvent(isInitialLoad: true));

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
        appBar: AppBar(title: Text("Home Page")),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              isLoadingMore = false; // ✅ Reset loading flag
              // Access products from first ProductModel
              final productList = state.products;

              return GridView.builder(
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Loading at end
                  }

                  final product = productList[index];
                  return ProductTile(
                    product: product,
                    onPressed: () {},
                    // product adding to cart
                    onTap: () {
                      context.read<CartBloc>().add(
                        AddToCartEvent(product: product),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.title} added to cart'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("No products found."));
            }
          },
        ),
      ),
    );
  }
}
