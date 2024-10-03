import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/utils/enums/order_enum.dart';

class Order {
  final String id;
  final List<Product> products;
  final DateTime orderingDate;
  final DateTime deliveryDate;
  final OrderStatus status;

  // Constructor for the Order class
  Order({
    required this.id,
    required this.products,
    required this.orderingDate,
    required this.deliveryDate,
    required this.status,
  });
}
