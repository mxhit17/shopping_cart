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
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    product.thumbnail ?? "x",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 8,
                  child: ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 12, // Reduced icon size
                    ),
                    label: Text(
                      "Add",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold), // Reduced text size
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent, // Customize color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6), // Reduced padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            6), // Slightly smaller border radius
                      ),
                      elevation: 3, // Slightly reduced shadow
                    ),
                  ),
                ),
              ],
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
        ],
      ),
    );
  }
}
