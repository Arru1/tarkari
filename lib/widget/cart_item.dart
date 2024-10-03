import 'package:final_year_project/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.cartItem});

  final Product cartItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          IconlyLight.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Remove from cart?"),
            content: const Text(
              "Do you want to remove this item from the cart?",
              style: TextStyle(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Remove",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        );
        return result ?? false;
      },
      child: SizedBox(
        height: 125,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            side: BorderSide(
              width: 0.2,
              color: Colors.grey.shade500,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                //image
                Container(
                  width: 90,
                  height: double.infinity,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(cartItem.image),
                    ),
                  ),
                ),
                //other info for cart
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cartItem.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            " Rs ${cartItem.price}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: const Color.fromARGB(255, 17, 138, 23),
                                ),
                          ),
                          SizedBox(
                            height: 20,
                            child: ToggleButtons(
                              onPressed: (index) {
                                if (index == 0) {
                                  //user wants to decrease the quantity
                                } else if (index == 2) {
                                  //user wants to increase the quantity
                                }
                              },
                              borderRadius: BorderRadius.circular(99),
                              isSelected: const [true, false, true],
                              selectedColor: Colors.green,
                              constraints: const BoxConstraints(
                                minHeight: 30,
                                minWidth: 30,
                              ),
                              children: const [
                                Icon(
                                  Icons.remove,
                                  size: 20,
                                ),
                                Text("2"),
                                Icon(
                                  Icons.add,
                                  size: 20,
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
