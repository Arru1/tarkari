import 'package:dio/dio.dart';
import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/main.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/model/transaction.dart';
import 'package:final_year_project/services/sendfcm.dart';
import 'package:final_year_project/views/footer.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderFormWidget extends StatefulWidget {
  final String productName;
  final int? quantity;
  final double price;
  final Product product;
  final String? sellerName;
  final int? id;
  final String? sellerPh;
  final String unit;
  final String? bechdakophone;

  OrderFormWidget({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.product,
    required this.sellerName,
    required this.id,
    required this.sellerPh,
    required this.unit,
    required this.bechdakophone,
  });

  @override
  _OrderFormWidgetState createState() => _OrderFormWidgetState();
}

class _OrderFormWidgetState extends State<OrderFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _deliveryAddress;
  late String _contactNumber;
  int itemQuantity = 0;
  int enteredQuantity = 0;

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.price;

    List<Product> productt = products.where((products) =>
            products.sellerName == '${widget.sellerName}' &&
            products.deliveryOption == 'Available' &&
            products.name != widget.productName).toList();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Product Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Product Name: ${widget.productName} ${widget.sellerPh}'),
                Text('Available Quantity: ${widget.quantity}'),
                Text('Price: \Rs ${totalPrice.toStringAsFixed(2)}'),
                Text('id :${widget.id}'),
                SizedBox(height: 16),
                Text(
                  'Customer Information:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Delivery Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter delivery address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _deliveryAddress = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact Number',),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _contactNumber = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Quantity',
                      hintText: "${widget.quantity}${widget.unit} available"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    enteredQuantity = int.tryParse(value) ?? 0;
                    if (enteredQuantity <= 0) {
                      return 'Quantity must be greater than zero';
                    }
                    if (enteredQuantity > (widget.quantity ?? 0)) {
                      return 'Quantity exceeds available quantity';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      itemQuantity = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 16),
               Row(
  children: [
    Text(
      'Total Price: ${widget.price * itemQuantity}',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    SizedBox(width: 10),
    ElevatedButton(
      onPressed: ()async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
         pay();
        }
      },
      child: Text('Pay With Khalti'),
    ),
  ],
),

                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pay() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(amount: 10000, productIdentity: 'fzone${widget.productName}', productName: widget.productName),
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.connectIPS,
        PaymentPreference.eBanking,
        PaymentPreference.mobileBanking
      ],
      onSuccess: (value) {
        verify(value.token, value.amount);
      },
      onFailure: (value) {},
    );
  }

  verify(String token, int amount) async {
    Dio dio = Dio();
    dio.options.headers = {
      "content-type": "application/json",
      "authorization": "Key test_secret_key_c9509c35a585441887dede250864c05e"
    };
    var jsonData = {
      "token": token,
      "amount": amount
    };
    try {
      var response = await dio.post("https://khalti.com/api/v2/payment/verify/", data: jsonData);
     if (response.statusCode == 200) {
  print(response.data);
  print("Hello KHalti");

  int? remainQty = widget.quantity! - itemQuantity;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  Transaction transaction = Transaction(
    boughtQuantity: enteredQuantity.toString(),
    buyerContact: prefs.getString(MyAppState.PHONENUMBER),
    buyerName: _name,
    changedQuantity: remainQty,
    deliveryAddress: _deliveryAddress,
    deliveryContact: _contactNumber,
    price: widget.price * enteredQuantity,
    productName: widget.productName,
    sellerContact: widget.sellerPh,
    bechdakophone: widget.bechdakophone,
  );

  Apiservice apis = ApiserviceImpl();
  await apis.addTransaction(transaction, widget.id);
  //await SendNotifcation.sendFCMNotification('', '' '', '', 'You Reicieved a New Order', '', '','');

 
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Order Placed Successfully'),
    ),
  );

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Footer()),
    (route) => false,
  );
}
 else {
        print(response.statusCode);
        print('bad response');
      }
    } catch (e) {
      print(e);
    }
  }
}
