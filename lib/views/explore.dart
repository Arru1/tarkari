import 'package:final_year_project/data/product_data.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/services/notificationhandling.dart';
import 'package:final_year_project/views/notification.dart';
import 'package:badges/badges.dart' as badges;
import 'package:final_year_project/views/product_card.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_year_project/main.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late NotificationService notificationService;
  String userName = '';
  List<Product> _searchResults = [];
  late TextEditingController _searchController;
  bool _isAvailableProductsSelected = true;
  bool _isLoading = true;
  bool isDeliveryOptionYes = true;
  String selectedCategory = 'Vegetables';
  TextEditingController _distanceController = TextEditingController();
// Default category selection

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (_searchResults.isEmpty) {
      fetchProducts();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    DateTime now = DateTime.now();
    String greeting = _getGreeting(now);
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(now);
    String nepaliDate = NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    String nepaliTime = NepaliDateFormat('hh:mm a').format(nepaliDateTime);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$greeting $userName",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                " $nepaliDate ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton.filledTonal(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationView(),
                    ),
                  );
                },
                icon: badges.Badge(
                  badgeContent: const Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  position: badges.BadgePosition.topEnd(top: -15, end: -12),
                  child: const Icon(IconlyBroken.notification),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          _performSearch(query);
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          isDense: true,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(99),
                            ),
                          ),
                          prefixIcon: const Icon(IconlyLight.search),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: IconButton.filled(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: AlertDialog(
                                  title: Text('Filter Options'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Delivery Option:'),
                                          SizedBox(
                                            width: 120,
                                            child: ToggleButtons(
                                              children: [
                                                Text('Yes'),
                                                Text('No'),
                                              ],
                                              isSelected: [
                                                isDeliveryOptionYes,
                                                !isDeliveryOptionYes,
                                              ],
                                              onPressed: (int index) {
                                                setState(() {
                                                  isDeliveryOptionYes =
                                                      index == 0;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      DropdownButtonFormField<String>(
                                        value: selectedCategory,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'Vegetables',
                                            child: Text('Vegetables'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Equipments',
                                            child: Text('Equipments'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Agrovet',
                                            child: Text('Agrovet'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Livestocks',
                                            child: Text('Livestocks'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Other',
                                            child: Text('Other'),
                                          ),
                                        ],
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(() {
                                              selectedCategory = newValue;
                                            });
                                          }
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller: _distanceController,
                                        decoration: InputDecoration(
                                          labelText: 'Distance',
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          print('Entered Distance: $value');
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _applyFilter();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Apply'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(IconlyLight.filter),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showAllProducts();
                      },
                      child: Text(
                        "All Products",
                        style: TextStyle(
                          color: _isAvailableProductsSelected
                              ? Colors.green
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showNearbyProducts();
                      },
                      child: Text(
                        "Near me",
                        style: TextStyle(
                          color: _isAvailableProductsSelected
                              ? Colors.black
                              : Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResults.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: _searchResults[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString(MyAppState.NAME)!;
    });
    await populateProductsFromAPI();
    setState(() {
      _searchResults = List.from(products);
      _isLoading = false;
    });
  }

  String _getGreeting(DateTime time) {
    var hour = time.hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else if (hour < 20) {
      return 'Good Evening!';
    } else {
      return 'Good Night!';
    }
  }

//sequential search
  void _performSearch(String query) {
    List<Product> matchedProducts = [];
    if (query.isNotEmpty) {
      for (int i = 0; i < products.length; i++) {
        String productName = products[i].name.toLowerCase();
        String queryLower = query.toLowerCase();
        bool found = false;
        for (int j = 0; j <= productName.length - queryLower.length; j++) {
          found = true;
          for (int k = 0; k < queryLower.length; k++) {
            if (productName[j + k] != queryLower[k]) {
              found = false;
              break;
            }
          }
          if (found) {
            matchedProducts.add(products[i]);
            break;
          }
        }
      }
    } else {
      matchedProducts = List.from(products);
    }
    setState(() {
      _searchResults = matchedProducts;
    });
  }

  void _applyFilter() {
    List<Product> filteredProducts = products.where((product) {
      bool nameMatches = product.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      bool deliveryOptionMatches =
          isDeliveryOptionYes ? product.deliveryOption == 'Available' : true;

      bool categoryMatches = product.category == selectedCategory;

      double? enteredDistance =
          double.tryParse(_distanceController.text) ?? 0.0;

      bool distanceMatches = product.haversineDistance! <= enteredDistance;

      return nameMatches &&
          deliveryOptionMatches &&
          categoryMatches &&
          distanceMatches;
    }).toList();

    setState(() {
      _searchResults = filteredProducts;
    });
  }

  void _showAllProducts() {
    setState(() {
      _isAvailableProductsSelected = true;
      _searchResults = List.from(products);
    });
  }

  void _showNearbyProducts() {
    final double maxDistance = 6;

    final List<Product> nearbyProducts = products.where((product) {
      return product.haversineDistance! <= maxDistance;
    }).toList();

    setState(() {
      _isAvailableProductsSelected = false;
      _searchResults = nearbyProducts;
    });
  }
}
