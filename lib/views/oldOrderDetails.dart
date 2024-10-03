import 'package:final_year_project/data/order_data.dart';
import 'package:final_year_project/utils/enums/order_enum.dart';
import 'package:final_year_project/widget/order_item.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final tabs = OrderStatus.values.map((e) => e.name).toList();
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Orders"),
          bottom: TabBar(
            isScrollable: true,
            tabs: List.generate(tabs.length, (index) {
              return Tab(
                text: tabs[index],
              );
            }),
          ),
        ),
        body: TabBarView(
          children: List.generate(tabs.length, (index) {
            final filteredOrders = orders
                .where((order) => order.status == OrderStatus.values[index])
                .toList();
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return OrderItem(order: order);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: filteredOrders.length,
            );
          }),
        ),
      ),
    );
  }
}
