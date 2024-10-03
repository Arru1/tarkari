import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/views/editform.dart';

class MyProductCard extends StatefulWidget {
  const MyProductCard({Key? key, required this.product}) : super(key: key);

  final AddItemDTO product;

  @override
  _MyProductCardState createState() => _MyProductCardState();
}

class _MyProductCardState extends State<MyProductCard> {
  TextEditingController _quantityController = TextEditingController();
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Edit Quantity", style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Enter available quantity'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isDeleting = true;
                        });

                        try {
                          int quantity = int.parse(_quantityController.text);
                          AddItemDTO additem = AddItemDTO(availableQuantity: quantity);
                          Apiservice apis = ApiserviceImpl();
                          await apis.updateProduct(additem, widget.product.id);
                          await populateProductsFromAPI();
Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Product quantity updated successfully')),
                          );

                          setState(() {}); // Rebuild the widget

                          Navigator.pop(context, _quantityController.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error updating product quantity')),
                          );
                        } finally {
                          setState(() {
                            _isDeleting = false;
                          });
                        }
                      },
                      child: _isDeleting ? CircularProgressIndicator() : Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 0.2,
            color: Colors.grey.shade500,
          ),
        ),
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                height: 140,
                alignment: Alignment.topRight,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.product.productImage!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        widget.product.name!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      'AvailableQty: ${widget.product.availableQuantity}'!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Rs ${widget.product.price}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              TextSpan(
                                text: "/${widget.product.unit}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        _isDeleting
                            ? CircularProgressIndicator()
                            : IconButton(
                                onPressed: () async {
                                  setState(() {
                                    _isDeleting = true;
                                  });

                                  try {
                                    Apiservice apiservice = ApiserviceImpl();
                                    await apiservice.deleteProduct(widget.product.id);
                                    await populateProductsFromAPI();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Product deleted successfully')),
                                    );
                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error deleting product')),
                                    );
                                  } finally {
                                    setState(() {
                                      _isDeleting = false;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
