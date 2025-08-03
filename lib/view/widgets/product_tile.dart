import 'package:flutter/material.dart';
import 'package:shoppr/data/model/product_items.dart';

class ProductTile extends StatelessWidget {
  final ProductItem product;
  final VoidCallback? onTap;
  void Function()? onPressed;

  ProductTile({
    Key? key,
    required this.product,
    this.onTap,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          // Product Image
          GestureDetector(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.thumbnail ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          IconButton(onPressed: onTap, icon: Icon(Icons.card_travel)),
        ],
      ),
    );
  }
}

/* 

Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.thumbnail ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Title
              Text(
                product.title ?? 'No Title',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Price & Discount
              Row(
                children: [
                  Text(
                    '₹${product.price?.toStringAsFixed(2) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  if (product.discountPercentage != null &&
                      product.discountPercentage! > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${product.discountPercentage!.toStringAsFixed(0)}% OFF',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 4),

              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating?.toStringAsFixed(1) ?? 'N/A'}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Availability
              Text(
                product.availabilityStatus ?? 'Available',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      (product.availabilityStatus?.toLowerCase() == 'in stock')
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),

*/
