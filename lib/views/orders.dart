import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/model/transaction.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  final String contact;

  const OrdersPage({Key? key, required this.contact}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Transaction>? receivedOrders;
  List<Transaction>? placedOrders;

  @override
  void initState() {
    super.initState();
    fetchReceivedOrders();
    fetchPlacedOrders();
  }

  Future<void> fetchReceivedOrders() async {
    Transaction transaction = Transaction(sellerContact: widget.contact); 
    Apiservice apis = ApiserviceImpl();
    final List<Transaction>? orders =
        await apis.getTransactionSelled(transaction);

   
      setState(() {
        receivedOrders = orders;
      });
     
  }

  Future<void> fetchPlacedOrders() async {
    Transaction transaction = Transaction(buyerContact: widget.contact);
    Apiservice apis = ApiserviceImpl();
    final List<Transaction>? orders =
        await apis.getTransactionBought(transaction);

    if (orders != null) {
      setState(() {
        placedOrders = orders;
      });
    } else {
      // Handle error or no data scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Received Orders"),
              Tab(text: "Placed Orders"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            receivedOrders != null
                ? ListView.builder(
                    itemCount: receivedOrders!.length,
                    itemBuilder: (context, index) {
                      final order = receivedOrders![index];
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.green,
                        ),
                        title: Text(order.productName!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            Text('Quantity: ${order.boughtQuantity}'),
                            Text('Buyer Contact: ${order.deliveryContact}'),
                            Text('Delivery Address : ${order.deliveryAddress}'),
                            Text('Buyer Name:${order.buyerName}'),
                            Text('Total Paid: ${order.price}')
                            // Add more Text widgets for additional information
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            placedOrders != null
                ? ListView.builder(
                    itemCount: placedOrders!.length,
                    itemBuilder: (context, index) {
                      final order = placedOrders![index];
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                       
                        title: Text(order.productName!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity: ${order.boughtQuantity}'),
                            Text('Seller Contact: ${order.bechdakophone}'),
                            Text('Total Paid: ${order.price}')
                            // Add more Text widgets for additional information
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
