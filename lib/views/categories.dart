import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/views/categoryDetail.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 22, // Adjust spacing between CategoryBox widgets
            runSpacing: 18, // Adjust run spacing between rows of CategoryBox widgets
            children: <Widget>[
              CategoryBox(
                title: '  Vegetables    ',
                imagePath: 'assets/images/1.jpg',
              ),
              CategoryBox(
                title: '    Agrovet        ',
                imagePath: 'assets/images/unnamed.jpg',
              ),
              CategoryBox(
                title: '     Equipments      ',
                imagePath: 'assets/images/2.PNG',
              ),
              CategoryBox(
                title: '    Others           ',
                imagePath: 'assets/images/4.jpg',
              ),
              CategoryBox(
                title: '    LiveStocks     ',
                imagePath: 'assets/images/home-im1.png',
              ),
              CategoryBox(
                title: '     Nursery       ',
                imagePath: 'assets/images/3.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  final String title;
  final String imagePath;

  CategoryBox({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          List<Product> filteredProducts = products
              .where((product) => product.category == title.trim())
              .toList();

          // Print debug message to check if filtered products are correct
          print('Filtered products for category $title: $filteredProducts');

          // Navigate to CategoryDetail screen with filtered products
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetail(
                product: filteredProducts,
                categoryTitle: title.trim(),
              ),
            ),
          );
        } catch (e, stackTrace) {
          // Catch any potential errors and print them to console
          print('Error occurred while navigating to CategoryDetail: $e');
          print('Stack Trace: $stackTrace');
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3.0,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
