import 'package:shoppr/core/network.dart';
import 'package:shoppr/data/model/product_model.dart';
import 'package:shoppr/data/model/product_items.dart';

class ProductRepository {
  final NetworkService _networkService = NetworkService();

  Future<ProductModel> getAllProducts({
    int limit = 10,
    int skip = 0,
    String? sortBy,
    String? order,
    String? select,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit, 'skip': skip};

    if (sortBy != null && order != null) {
      queryParams['sortBy'] = sortBy;
      queryParams['order'] = order;
    }

    if (select != null) {
      queryParams['select'] = select;
    }

    final data = await _networkService.get(
      '/products',
      queryParams: queryParams,
    );

    return ProductModel.fromJson(data);
  }

  Future<ProductItem> getProductById(int id) async {
    final data = await _networkService.get('/products/$id');
    return ProductItem.fromJson(data);
  }

  Future<ProductModel> searchProducts(String query) async {
    final data = await _networkService.get(
      '/products/search',
      queryParams: {'q': query},
    );
    return ProductModel.fromJson(data);
  }
}
