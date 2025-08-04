import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoppr/data/model/product_items.dart';
import 'package:shoppr/view/pages/order_success_page%20.dart';
import 'package:shoppr/view/widgets/custom_button.dart';
import 'package:shoppr/view_model/cart_page/bloc/cart_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductItem product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // quantity
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title ?? "Product Detail")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              if (product.thumbnail != null)
                Center(
                  child: Image.network(
                    product.thumbnail!,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Button to decrease quantity
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      final minQty = product.minimumOrderQuantity ?? 1;
                      print("Decrease out top");
                      if (_quantity > 1) {
                        setState(() {
                          print("${product.minimumOrderQuantity}");
                          _quantity--;
                        });
                        print("Decrease out bot");
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  Text("$_quantity", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  // Button to increase quantity
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () {
                      if (_quantity < (product.minimumOrderQuantity ?? 1)) {
                        setState(() {
                          _quantity++;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Minimum order is ${product.minimumOrderQuantity}.",
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                product.title ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Brand
              Text(
                product.brand ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Description
              Text(product.description ?? '', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),

              // Price
              Row(
                children: [
                  Text(
                    "-${product.discountPercentage}%",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      // Text('Price: ', style: TextStyle(fontSize: 16)),
                      Text(
                        '₹${product.price}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Category
              Text(
                'Category: ${product.category}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('${product.rating ?? "N/A"}'),
                ],
              ),
              const SizedBox(height: 8),
              // Stock
              Text('Stock: ${product.stock}', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              // Tags
              Text(
                'Tags: ${product.tags?.join(", ") ?? "N/A"}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Warranty & Shipping Info
              Text(
                'Warranty: ${product.warrantyInformation}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Shipping Info
              Text(
                'Shipping Info: ${product.shippingInformation}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Weight
              Text(
                'Weight : ${product.weight}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Dimensions
              Text(
                'Dimensions: ${product.dimensions != null ? "${product.dimensions!.width} x ${product.dimensions!.height} x ${product.dimensions!.depth}" : "N/A"}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Minimum Order Quantity
              Text(
                'Minimum Order Quantity : ${product.minimumOrderQuantity}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Return Policy
              Text(
                'Return Policy : ${product.returnPolicy}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Customer Reviews
              if (product.reviews != null && product.reviews!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.reviews!
                      .map(
                        (review) => Text(
                          '- ${review.reviewerName ?? "Anonymous"}: ${review.comment ?? ""}',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                      .toList(),
                )
              else
                Text('No reviews yet.'),

              const SizedBox(height: 8),

              // Created / Updated Date
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created: ${product.meta?.createdAt ?? "N/A"}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Updated: ${product.meta?.updatedAt ?? "N/A"}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              SizedBox(height: 30),

              // Add to cart button
              CustomButton(
                onTap: () {
                  // Add To Cart
                  context.read<CartBloc>().add(
                    AddToCartEvent(product: product, quantity: _quantity),
                  );

                  // Message
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
                color: Colors.blue,
                text: "Add to cart",
              ),

              SizedBox(height: 22),

              // Purchase button
              CustomButton(
                onTap: () {
                  // Purchase
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderSuccessPage()),
                  );
                },
                color: Colors.green,
                text: "Purchase",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
