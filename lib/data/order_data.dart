import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/model/order.dart';
import 'package:final_year_project/utils/enums/order_enum.dart';

List<Order> orders = [
  Order(
    id: "422",
    products: products.reversed.take(3).toList(),
    orderingDate: DateTime.utc(2023, 1, 1),
    deliveryDate: DateTime.utc(2023, 1, 3),
    status: OrderStatus.Delivered,
  ),
  Order(
    id: "423",
    products: products.reversed.take(1).toList(),
    orderingDate: DateTime.utc(2023, 1, 2),
    deliveryDate: DateTime.utc(2023, 1, 3),
    status: OrderStatus.Processing,
  ),
  Order(
    id: "423",
    products: products.reversed.take(3).toList(),
    orderingDate: DateTime.utc(2023, 1, 4),
    deliveryDate: DateTime.utc(2023, 1, 11),
    status: OrderStatus.Delivered,
  ),
  Order(
    id: "424",
    products: products.reversed.skip(3).toList(),
    orderingDate: DateTime.utc(2023, 1, 8),
    deliveryDate: DateTime.utc(2023, 1, 11),
    status: OrderStatus.Processing,
  ),
  Order(
    id: "425",
    products: products.reversed.skip(3).toList(),
    orderingDate: DateTime.utc(2023, 1, 11),
    deliveryDate: DateTime.utc(2023, 1, 15),
    status: OrderStatus.Processing,
  ),
  Order(
    id: "426",
    products: products.reversed.skip(3).take(1).toList(),
    orderingDate: DateTime.utc(2023, 1, 11),
    deliveryDate: DateTime.utc(2023, 1, 15),
    status: OrderStatus.Picking,
  ),
  Order(
    id: "429",
    products: products.reversed.skip(3).take(1).toList(),
    orderingDate: DateTime.utc(2023, 1, 11),
    deliveryDate: DateTime.utc(2023, 1, 15),
    status: OrderStatus.Shipping,
  ),
];
