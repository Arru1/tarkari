import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/main.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/views/myitempage.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/views/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyItems extends StatefulWidget {
  const MyItems({Key? key});

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  List<AddItemDTO>? _myProducts;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMyProducts(); // Call the method to fetch products
  }

  // Method to fetch products
  Future<void> _fetchMyProducts() async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    Apiservice apis = ApiserviceImpl();
    List<AddItemDTO>? products = await apis.fetchMyProducts();
    if (products != null) {
      setState(() {
        _myProducts = products;
        _isLoading = false; // Reset loading state
      });
    } else {
      // Handle error or no data scenario
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Items'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : _myProducts == null || _myProducts!.isEmpty
              ? Center(
                  child: Text('No products available'),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _myProducts!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return MyProductCard(
                      product: _myProducts![index],
                    );
                  },
                ),
    );
  }
}
