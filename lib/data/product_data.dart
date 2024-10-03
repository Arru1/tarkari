import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/util/haversine.dart';
import 'package:final_year_project/util/vincenity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<Product> products = [];
Map<String, double> commodityPrices = {};
Map<String, String> commodityUnits = {}; 

// Fetch data from API and store commodity names with their prices and units
Future<void> fetchCommodityPrices() async {
  final response = await http.get(Uri.parse('https://kalimatimarket.gov.np/api/daily-prices/en'));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final List<dynamic> prices = jsonData['prices'];
    commodityPrices = Map.fromIterable(prices,
        key: (price) => price['commodityname'], value: (price) => double.parse(price['avgprice']));
    
    // Extract commodity units
    commodityUnits = Map.fromIterable(prices,
        key: (price) => price['commodityname'], value: (price) => price['commodityunit']);
  } else {
    print('Failed to fetch data from API');
  }
}

// Fetch and populate products from API
populateProductsFromAPI() async {
  // Fetch commodity names, prices, and units from API
  await fetchCommodityPrices();

  Apiservice apiservice = ApiserviceImpl();
  final List<AddItemDTO>? responseList = await apiservice.fetchProduct();
  if (responseList != null) {
    // Check if names match with commodity names 
    for (AddItemDTO item in responseList) {
      if (commodityPrices.containsKey(item.name)) {
        double newPrice = commodityPrices[item.name]!;
        item.price = newPrice.toString();
        print('Match found for ${item.name}, Price: $newPrice');

        // Fetch the unit 
        if (commodityUnits.containsKey(item.name)) {
          item.unit = commodityUnits[item.name]!;
        }
      
      }
       item.haversineDistance= await HaversineDistance.calculateDistanceWithCurrentLocation(item.latitude, item.longitude);
    }
 
    // Mapping each AddItemDTO to Product
    List<Product> fetchedProducts = responseList.map((item) {
      return Product(
        name: item.name ?? '',
        description: item.description ?? '',
        image: item.productImage ?? '',
        price: double.tryParse(item.price ?? '') ?? 0.0,
        unit: item.unit ?? '', 
        rating: 0.0, 
        sellerName: item.sellerName,
        location: item.location,
        availableQuantity:item.availableQuantity, 
        deliveryDescrip: item.deliveryDescrip ?? '',
        deliveryOption: item.deliveryOption,
        category: item.category,
        id: item.id,
        haversineDistance: item.haversineDistance,
        seller_ph: item.phonenumber,
        lat:item.latitude,
        longi:item.longitude,
        usernamePh: item.usernamePh

        
      );
    }).toList();

    // Update the products list
    products = fetchedProducts.where((product) => product.availableQuantity! > 0).toList();
  }
}
