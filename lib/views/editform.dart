import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/model/product.dart';
import 'package:flutter/material.dart';

class EditForm extends StatefulWidget {
  final AddItemDTO product;

  EditForm(this.product, {Key? key}) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24), // Adjust content padding
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Available Quantity'),
              controller: _quantityController,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              int quantity = int.parse(_quantityController.text);
              AddItemDTO additem = AddItemDTO(availableQuantity: quantity);
              Apiservice apis = new ApiserviceImpl();
              await apis.updateProduct(additem, widget.product.id);
              await populateProductsFromAPI();
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
