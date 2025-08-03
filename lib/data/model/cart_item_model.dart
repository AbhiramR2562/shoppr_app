import 'package:shoppr/data/model/product_items.dart';

class CartItem {
  final ProductItem product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
