import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:final_year_project/model/vegetablemodel.dart';

class DailyPricesTable extends StatefulWidget {
  @override
  _DailyPricesTableState createState() => _DailyPricesTableState();
}

class _DailyPricesTableState extends State<DailyPricesTable> {
  List<DailyPrice> dailyPrices = []; // Initialize as an empty list

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      Response response = await Dio().get('https://kalimatimarket.gov.np/api/daily-prices/en');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['prices'];
        setState(() {
          dailyPrices = data.map((item) => DailyPrice.fromJson(item)).toList();
          isLoading = false; // Set loading to false when data is fetched
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false; // Set loading to false in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        width: double.infinity,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(), 
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal, 
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, 
                  child: DataTable(
                    columnSpacing: 10.0,
                    headingRowColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 145, 240, 148)),
                    columns: [
                      DataColumn(label: Text('Item', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Min', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Max', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Avg', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: dailyPrices.map((price) {
                      return DataRow(cells: [
                        DataCell(Container(width: isSmallScreen ? 80 : 100, child: Text(price.commodityName))),
                        DataCell(Container(width: isSmallScreen ? 40 : 60, child: Text(price.commodityUnit))),
                        DataCell(Container(width: isSmallScreen ? 40 : 60, child: Text(price.minPrice))),
                        DataCell(Container(width: isSmallScreen ? 40 : 60, child: Text(price.maxPrice))),
                        DataCell(Container(width: isSmallScreen ? 40 : 60, child: Text(price.avgPrice))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
