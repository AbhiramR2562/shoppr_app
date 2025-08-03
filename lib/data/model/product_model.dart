import 'package:shoppr/data/model/product_items.dart';

class ProductModel {
  // Fields representing API response
  final List<ProductItem> products;
  final int total;
  final int skip;
  final int limit;

  // Constructor with default values
  ProductModel({
    this.products = const [],
    this.total = 0,
    this.skip = 0,
    this.limit = 0,
  });

  // Factory method to create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductItem.fromJson(e))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }

  // Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  // Create a new ProductModel with some fields changed
  ProductModel copyWith({
    List<ProductItem>? products,
    int? total,
    int? skip,
    int? limit,
  }) {
    return ProductModel(
      products: products ?? this.products,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }
}
