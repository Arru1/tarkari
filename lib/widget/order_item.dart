import 'package:final_year_project/model/order.dart';
import 'package:final_year_project/widget/order_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({Key? key, required this.order, this.visibleProduct = 2})
      : super(key: key);
  final Order order;
  final int visibleProduct;

  @override
  Widget build(BuildContext context) {
    final totalPrice = order.products.fold(0.0, (acc, e) => acc + e.price);
    final products = order.products.take(visibleProduct).toList();
    ThemeData theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Order: ${order.id}",
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '(${order.products.length} Items)',
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(width: 5.0),
                Text("\ Rs ${totalPrice.toStringAsFixed(2)}")
              ],
            ),
            const SizedBox(height: 10),
            ...List.generate(products.length, (index) {
              return OrderProduct(
                product: products[index],
                order: order,
              );
            }),
            if (order.products.length > 2)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                              itemCount: order.products.length,
                              padding: EdgeInsets.all(14),
                              itemBuilder: (context, index) {
                                final product = order.products[index];
                                return OrderProduct(
                                    order: order, product: product);
                              }),
                        );
                      },
                    );
                  },
                  label: const Text("View all"),
                  icon: const Icon(IconlyBold.arrowDown2),
                ),
              )
          ],
        ),
      ),
    );
  }
}
