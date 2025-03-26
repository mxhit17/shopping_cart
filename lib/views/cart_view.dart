import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shoping_cart/models/product_model.dart';
import 'package:shoping_cart/utils/prefs/preference_manager.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  late final prefs;
  late List<Product> allProducts;

  void initState() {
    super.initState();
    prefs = GetIt.instance<PreferencesManager>();
    allProducts = prefs.getCartProducts();
  }

  double totalAmount = 0;

  String getDiscountedPrice(Product product) {
    return (product.price / (1 - product.discountPercentage / 100))
        .toStringAsFixed(2);
  }

  String getTotalAmount(List<Product> products) {
    totalAmount = 0;

    for (int i = 0; i < products.length; i++) {
      int quantity = int.tryParse(products[i].quantity ?? "1") ?? 1;

      totalAmount = totalAmount + (products[i].price * quantity);
      // totalAmount =
      //     totalAmount + (double.parse(getDiscountedPrice(products[i])));
    }

    return totalAmount.toStringAsFixed(2);
  }

  int getTotalItems() {
    return allProducts.fold(
        0, (sum, item) => (sum + int.parse(item.quantity ?? "1")).toInt());
  }

  void updateQuantity(int index, int change, List<Product> allProduct) {
    setState(() {
      int currentQuantity =
          int.tryParse(allProduct[index].quantity ?? "1") ?? 1;
      int updatedQuantity = (currentQuantity + change)
          .clamp(1, double.infinity)
          .toInt(); // Ensure min quantity is 1

      allProduct[index] =
          allProduct[index].copyWith(quantity: updatedQuantity.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final _remPref = GetIt.instance<PreferencesManager>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text("Cart", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                final item = allProducts[index];
                return Stack(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Image.network(item.thumbnail ?? "x"),
                        title: Text(item.title ?? "x",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.brand ?? "x"),
                            Row(
                              children: [
                                Text("₹${getDiscountedPrice(item)}",
                                    style: const TextStyle(
                                        decoration:
                                            TextDecoration.lineThrough)),
                                const SizedBox(width: 5),
                                Text("₹${item.price}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text("${item.discountPercentage}% OFF",
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () =>
                                  updateQuantity(index, -1, allProducts),
                            ),
                            Text(item.quantity ?? "1"),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () =>
                                  updateQuantity(index, 1, allProducts),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _remPref.removeProductFromCart(index);
                            allProducts = _remPref.getCartProducts();
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Amount Price", style: TextStyle(fontSize: 16)),
                    Text("₹${getTotalAmount(allProducts)}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Check Out", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 5),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Text("${getTotalItems()}",
                            style: const TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
