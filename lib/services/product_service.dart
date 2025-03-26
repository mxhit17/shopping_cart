import 'package:get_it/get_it.dart';
import 'package:shoping_cart/models/product_model.dart';
import 'package:shoping_cart/utils/http_service.dart';
import 'package:shoping_cart/utils/urls.dart';

class ProductService {
  late HttpService httpService;

  ProductService() {
    httpService = GetIt.instance<HttpService>();
  }

  Future<List<Product>> fetchProducts(
      {required int skip, required int limit}) async {
    try {
      final response = await httpService.get(Urls.PRODUCTS, queryParams: {
        "skip": skip,
        "limit": limit,
      });

      print("API Response: ${response?.data}"); // Log full API response

      final List<dynamic> productsJson = response?.data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print("Error fetching products: $e");
      print(stackTrace);
      throw Exception("Failed to load products: $e");
    }
  }
}
