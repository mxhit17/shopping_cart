import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoping_cart/models/product_model.dart';
import 'package:shoping_cart/services/product_service.dart';

class ProductsController extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService productService;

  ProductsController(this.productService) : super(const AsyncValue.data([]));

  int _skip = 0;
  final int _limit = 10;
  bool _isLastPage = false;
  bool isLoadingMore = false;
  List<Product> _products = [];

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (state is AsyncLoading && !isLoadMore) return;
    if (isLoadMore && _isLastPage) return;

    try {
      isLoadingMore = true;
      if (!isLoadMore) {
        state = const AsyncValue.loading();
        _skip = 0;
        _products.clear();
      }

      final newProducts =
          await productService.fetchProducts(skip: _skip, limit: _limit);
      if (newProducts.isEmpty) {
        _isLastPage = true;
      } else {
        _products.addAll(newProducts);
        _skip += _limit;
      }

      isLoadingMore = false;
      state = AsyncValue.data([..._products]);
    } catch (e, stackTrace) {
      isLoadingMore = false; // Reset the flag
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void loadMore() {
    fetchProducts(isLoadMore: true);
  }
}

final productServiceProvider =
    Provider<ProductService>((ref) => ProductService());

final productsControllerProvider =
    StateNotifierProvider<ProductsController, AsyncValue<List<Product>>>((ref) {
  final service = ref.read(productServiceProvider);
  return ProductsController(service);
});
