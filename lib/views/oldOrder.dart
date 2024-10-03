import 'package:easy_stepper/easy_stepper.dart';
import 'package:final_year_project/model/order.dart';
import 'package:final_year_project/utils/enums/extension/data_fordate.dart';
import 'package:final_year_project/utils/enums/order_enum.dart';
import 'package:final_year_project/widget/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    const steps = OrderStatus.values;
    final activeStep = steps.indexOf(order.status);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details "),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EasyStepper(
            activeStep:
                activeStep == steps.length - 1 ? activeStep + 1 : activeStep,
            stepRadius: 8,
            activeStepBackgroundColor: Colors.black,
            finishedStepTextColor: Theme.of(context).colorScheme.primary,
            lineStyle: LineStyle(
                defaultLineColor: Colors.grey.shade300,
                lineLength:
                    (MediaQuery.of(context).size.width * 0.7) / steps.length),
            steps: List.generate(
              steps.length,
              (index) {
                return EasyStep(
                  icon: Icon(Icons.local_shipping),
                  finishIcon: const Icon(Icons.done),
                  title: steps[index].name,
                  topTitle: true,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Color.fromARGB(255, 216, 201, 201)),
            ),
            elevation: 0.1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order: ${order.id}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Chip(
                            shape: const StadiumBorder(),
                            side: BorderSide.none,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.4),
                            labelPadding: EdgeInsets.zero,
                            avatar: const Icon(Icons.fire_truck),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            label: Text(steps[activeStep].name))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery estimate "),
                      Text(
                        order.deliveryDate.formatDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Shah Rukh Khan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(IconlyLight.home, size: 15),
                      SizedBox(width: 5),
                      Expanded(
                          child: Text("Banepa, Nala-Kavrepalanchowk, shera-5"))
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(IconlyLight.call, size: 15),
                      SizedBox(width: 5),
                      Expanded(child: Text("9821123456"))
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment Method"),
                      Text(
                        "Khalti  *******56",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          OrderItem(
            order: order,
            visibleProduct: 1,
          ),
        ],
      ),
    );
  }
}
