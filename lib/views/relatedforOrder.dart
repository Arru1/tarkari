import 'package:flutter/material.dart';
import 'package:final_year_project/model/product.dart';

class OrderRelated extends StatelessWidget {
  const OrderRelated({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0.1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          width: 0.2,
          color: Colors.grey.shade500,
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: 100,
            alignment: Alignment.topRight,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  product.image,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Row(
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: IconButton.filled(
                          padding: EdgeInsets.zero,
                          onPressed: () {

                            print('The product id is${product.id}');
                            print('The available quantity is${product.availableQuantity}');
                          //  product.availableQuantity=product.availableQuantity;

                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Rs ${product.price}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextSpan(
                            text: " per ${product.unit}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  " Available Qty : ${product.availableQuantity}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}