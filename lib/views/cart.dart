import 'dart:math';

import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/widget/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = products.take(4).toList();
    final totalPrice =
        cartItems.map((e) => e.price).reduce((acc, cur) => acc + cur);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ...List.generate(cartItems.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: CartItem(cartItem: cartItems[index]),
              );
            }),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total (${cartItems.length})",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  " Rs $totalPrice",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
            SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {},
              icon: Icon(IconlyBold.arrowRight),
              label: Text("Proceed to Checkout"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
            )
          ],
        ));
  }
}
