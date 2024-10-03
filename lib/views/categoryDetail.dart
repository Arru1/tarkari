import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/views/product_card.dart';
import 'package:flutter/material.dart';

class CategoryDetail extends StatefulWidget {
  final String categoryTitle;
  final List<Product> product;

  const CategoryDetail({
    Key? key,
    required this.categoryTitle,
    required this.product,
  }) : super(key: key);

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryTitle),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.product.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: widget.product[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
