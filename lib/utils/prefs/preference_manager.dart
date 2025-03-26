import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoping_cart/models/product_model.dart';

class PreferencesManager {
  static const String CART_ITEMS = 'cart_items';

  // Singleton instance
  static final PreferencesManager _instance = PreferencesManager._internal();

  // SharedPreferences instance
  late final SharedPreferences _prefs;

  // Private constructor
  PreferencesManager._internal();

  // Factory method to initialize the SharedPreferences
  static Future<PreferencesManager> create(SharedPreferences prefs) async {
    _instance._prefs = prefs;
    return _instance;
  }

  // Method to add a product to the cart
  Future<void> addProductToCart(Product product) async {
    List<String> cartList = _prefs.getStringList(CART_ITEMS) ?? [];
    cartList.add(jsonEncode(product.toJson()));
    await _prefs.setStringList(CART_ITEMS, cartList);
  }

  // Method to retrieve the cart items
  List<Product> getCartProducts() {
    List<String> cartList = _prefs.getStringList(CART_ITEMS) ?? [];
    return cartList.map((item) => Product.fromJson(jsonDecode(item))).toList();
  }

  // Method to remove a product from the cart by index
  Future<void> removeProductFromCart(int index) async {
    List<String> cartList = _prefs.getStringList(CART_ITEMS) ?? [];
    if (index >= 0 && index < cartList.length) {
      cartList.removeAt(index);
      await _prefs.setStringList(CART_ITEMS, cartList);
    }
  }

  // Method to clear the cart
  Future<void> clearCart() async {
    await _prefs.remove(CART_ITEMS);
  }

  // Method to remove a key
  Future<void> removeKey(String key) async {
    await _prefs.remove(key);
  }

  // Method to clear all preferences
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
