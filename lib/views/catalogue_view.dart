import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shoping_cart/controller/product_controller.dart';
import 'package:shoping_cart/utils/prefs/preference_manager.dart';
import 'package:shoping_cart/views/cart_view.dart';
import 'dart:async';
import 'package:shoping_cart/widget/product_card.dart';

class CatalogueScreen extends ConsumerStatefulWidget {
  const CatalogueScreen({super.key});

  @override
  _CatalogueScreenState createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends ConsumerState<CatalogueScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productsControllerProvider.notifier).fetchProducts();
    });

    // _scrollController.addListener(_scrollListener);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!ref.read(productsControllerProvider.notifier).isLoadingMore) {
          ref.read(productsControllerProvider.notifier).loadMore();
        }
      }
    });
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     ref.read(productsControllerProvider.notifier).loadMore();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);
    final prefs = GetIt.instance<PreferencesManager>();

    final totalItemsInCart = prefs.getCartProducts().length;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 236, 238),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Catalogue'),
        backgroundColor: Color.fromARGB(255, 252, 236, 238),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    totalItemsInCart.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: productsState.when(
        data: (products) => GridView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          // itemCount: products.length +
          //     (ref.watch(productsControllerProvider.notifier).isLoadingMore
          //         ? 1
          //         : 0),
          itemCount:
              productsState.isLoading ? products.length + 1 : products.length,
          itemBuilder: (context, index) {
            if (index == products.length &&
                ref.watch(productsControllerProvider).isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (index >= products.length)
              return SizedBox.shrink(); // Prevent index out of range error

            final product = products[index];
            return ProductCard(
              product: product,
              onAdd: () {
                setState(() {
                  prefs.addProductToCart(product);
                });
                print("Add product to cart");
              },
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading products. $e")),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
