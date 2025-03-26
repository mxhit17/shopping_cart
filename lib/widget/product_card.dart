import 'package:flutter/material.dart';
import 'package:shoping_cart/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({Key? key, required this.product, required this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                product.thumbnail ?? "x",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title ?? "x",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(product.brand ?? "x",
                    style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    Text(
                      "₹${product.price.toStringAsFixed(2)}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "₹${(product.price / (1 - product.discountPercentage / 100)).toStringAsFixed(2)}",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${product.discountPercentage}% OFF",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: onAdd,
              child: Text("Add"),
            ),
          ),
        ],
      ),
    );
  }
}
