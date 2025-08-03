import 'package:flutter/material.dart';
import 'package:shoppr/data/model/product_items.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductItem product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title ?? "Product Detail")),
      body: Padding(
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
                ),
              ),
            const SizedBox(height: 16),

            // Title
            Text(
              product.title ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Description
            Text(product.description ?? '', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            // Price
            Text(
              '₹${product.price}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),

            // Category
            Text(
              'Category: ${product.category}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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
          ],
        ),
      ),
    );
  }
}
