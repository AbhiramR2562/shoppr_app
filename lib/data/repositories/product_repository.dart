import 'package:shoppr/core/network.dart';
import 'package:shoppr/data/model/product_model.dart';
import 'package:shoppr/data/model/product_items.dart';

class ProductRepository {
  // Create an instance of the NetworkService to make API calls
  final NetworkService _networkService = NetworkService();

  // Fetch all products with optional pagination, sorting, and selected fields
  Future<ProductModel> getAllProducts({
    int limit = 10,
    int skip = 0,
    String? sortBy,
    String? order,
    String? select,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit, 'skip': skip};

    // Add sorting if provided
    if (sortBy != null && order != null) {
      queryParams['sortBy'] = sortBy;
      queryParams['order'] = order;
    }

    // Add selected fields if provided
    if (select != null) {
      queryParams['select'] = select;
    }

    // GET request
    final data = await _networkService.get(
      '/products',
      queryParams: queryParams,
    );

    return ProductModel.fromJson(data);
  }

  // Fetch a single product by its ID
  Future<ProductItem> getProductById(int id) async {
    // Make GET request
    final data = await _networkService.get('/products/$id');
    // Convert the response into a ProductItem model
    return ProductItem.fromJson(data);
  }

  // Search for products
  Future<ProductModel> searchProducts(String query) async {
    final data = await _networkService.get(
      '/products/search',
      queryParams: {'q': query},
    );
    return ProductModel.fromJson(data);
  }

  // get all category's
  Future<List<String>> getCategories() async {
    final data = await _networkService.get('/products/category-list');
    // Convert the result into a list of strings
    return List<String>.from(data);
  }

  // Get all products for a given category
  Future<ProductModel> getProductByCategory(String category) async {
    final data = await _networkService.get('/products/category/$category');
    return ProductModel.fromJson(data);
  }
}
