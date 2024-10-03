import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/views/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetailsPage(product: product),
        ));
      },
      child: Card(
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
              height: 140,
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
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyMedium,
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
                      // Icon
                      // SizedBox(
                      //   width: 30,
                      //   height: 30,
                      //   child: IconButton.filled(
                      //     padding: EdgeInsets.zero,
                      //     onPressed: () {},
                      //     icon: const Icon(Icons.add),
                      //   ),
                      // ),
                    ],
                  ),
                  Text("Available Qty : ${product.availableQuantity}${product.unit}")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
