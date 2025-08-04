import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoppr/data/model/product_items.dart';

class ProductTile extends StatelessWidget {
  final ProductItem product;

  // cart Button
  final VoidCallback? onTap;

  // image is tapped
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
      width: 158,
      height: 184,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, top: 8, bottom: 8),
                  // Product Image with shimmer loading
                  child: ClipRRect(
                    child: Image.network(
                      product.images != null && product.images!.isNotEmpty
                          ? product
                                .images!
                                .first // Get the first image from the list
                          : '',
                      width: 115,
                      height: 116,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // If image is loaded, return it
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 115,
                            height: 116,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            product.title != null && product.title!.length > 20
                                ? '${product.title!.substring(0, 20)}...' // Trim and add '...'
                                : product.title ??
                                      '', // Use full title if it's shorter
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Category
                          Text(
                            product.category ?? '',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          // Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('${product.rating ?? "N/A"}'),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),

                              // Discount Percentage
                              Text(
                                "${product.discountPercentage} %",
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Price
                          Row(
                            children: [
                              const Text(
                                "\$",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${product.price ?? 0}",
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 19.78),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Cart Button
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: IconButton(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
