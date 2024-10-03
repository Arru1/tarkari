import 'dart:math';

import 'package:final_year_project/model/order.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/views/oldOrder.dart';
import 'package:flutter/material.dart';

class OrderProduct extends StatelessWidget {
  const OrderProduct({super.key, required this.order, required this.product});
  final Order order;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OrderDetailsPage(order: order),
        ));
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(product.image),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\ Rs ${product.price}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    Text("Qty: ${Random().nextInt(4) + 1}")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
