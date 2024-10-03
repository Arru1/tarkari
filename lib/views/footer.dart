import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/views/additemForm.dart';
import 'package:final_year_project/views/categories.dart';
import 'package:final_year_project/views/explore.dart';
import 'package:final_year_project/views/profile.dart';
import 'package:final_year_project/views/vegeprice.dart';
import 'package:flutter/material.dart';


class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _Footer();
}

class _Footer extends State<Footer> {
  String userName = '';
  List<Widget> widgetList = [
    const ExplorePage(), //0
    DailyPricesTable(), //1
    AddItemForm(),//2
    CategoriesPage(), //3
    const ProfilePage(), //4
  ];
  int selectedTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState()  {
  

      
    super.initState();
    fetchProductsData();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: widgetList[selectedTab],
    bottomNavigationBar: BottomNavigationBar(
      onTap: (value) {
        setState(() {
          selectedTab = value;
        });
      },
      //color
      selectedItemColor: Colors.green[400],
      unselectedItemColor: Colors.black38,
      currentIndex: selectedTab,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Market"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Sell"),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
        BottomNavigationBarItem(icon: Icon(Icons.person_3), label: "Profile"),
      ],
    ),
  );
      
  }

 void fetchProductsData () async

 {
  await populateProductsFromAPI;
 }
 
}
