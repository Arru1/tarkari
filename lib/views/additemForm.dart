import 'package:final_year_project/data/product_data.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/main.dart';
import 'package:final_year_project/views/map.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({Key? key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemForm> {
  String _selectedCategory = 'Vegetables';
  String _selectedVegetable = '';
  String _selectedPrice = '';
  String _deliveryOption = 'Not Available';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _deliveryDesController = TextEditingController();
  final _locationController = TextEditingController();
  final _unitController = TextEditingController();
  final _quantityController = TextEditingController();
  List<Map<String, dynamic>> _vegetablePrices = [];
  File? _pickedImage;
  double? latitude1, longitude1;
  String _enteredName = '';
  @override
  void initState() {
    super.initState();
    _fetchDefaultValues();
  }

  Future<void> _fetchDefaultValues() async {
    try {
      final response =
          await Dio().get('https://kalimatimarket.gov.np/api/daily-prices/en');

      if (response.statusCode == 200) {
        final jsonData = response.data;
        final List<Map<String, dynamic>> allPrices =
            List<Map<String, dynamic>>.from(jsonData['prices']);
        _vegetablePrices = allPrices
            .where((element) =>
                element['commodityname'] != null &&
                element['commodityname'].isNotEmpty)
            .toList();
        if (_vegetablePrices.isNotEmpty) {
          setState(() {
            _selectedVegetable = _vegetablePrices[0]['commodityname'];
            _selectedPrice = _vegetablePrices[0]['avgprice'];
            _priceController.text = _selectedPrice;
          });
        }
      } else {
        throw Exception('Failed to load default values');
      }
    } catch (error) {
      print('Error fetching default values: $error');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void handleLocationSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    ).then((value) {
      if (value != null &&
          value['latitude'] != null &&
          value['longitude'] != null) {
        setState(() {
          latitude1 = value['latitude'];
          longitude1 = value['longitude'];
          print(latitude1);
          print(longitude1);
        });
      } else {
        print("latitude or longitude is null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    if (value == 'Vegetables') {
                      _priceController.clear();
                      if (_vegetablePrices.isNotEmpty) {
                        _selectedVegetable =
                            _vegetablePrices[0]['commodityname'];
                        _selectedPrice = _vegetablePrices[0]['avgprice'];
                        _priceController.text = _selectedPrice;
                        // Update name controller with selected vegetable
                      } else {
                        _selectedVegetable = '';
                        _selectedPrice = '';
                      }
                    } else {
                      _nameController.text =
                          ''; // Clear the name controller when category is not 'Vegetables'
                    }
                  });
                },
                items: [
                  'Vegetables',
                  'Agrovet',
                  'Equipments',
                  'Others',
                  'LiveStocks',
                  'Nursery'
                ].map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (_selectedCategory != 'Vegetables') ...[
                _buildFormField(
                  label: 'Name',
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    _enteredName =
                        value; // Update _enteredName with the user-entered value
                  },
                ),
                SizedBox(height: 10),
                _buildFormField(
                  label: 'Price',
                  controller: _priceController,
                  keyboardType: TextInputType.text,
                ),
              ],
              if (_selectedCategory == 'Vegetables') ...[
                DropdownButtonFormField<String>(
                  value: _selectedVegetable,
                  onChanged: (value) {
                    setState(() {
                      _selectedVegetable = value!;
                      _selectedPrice = _vegetablePrices.firstWhere((element) =>
                          element['commodityname'] == value)['avgprice'];
                      _priceController.text = _selectedPrice;
                      _enteredName = _selectedVegetable;
                    });
                  },
                  items:
                      _vegetablePrices.map<DropdownMenuItem<String>>((price) {
                    return DropdownMenuItem<String>(
                      value: price['commodityname'],
                      child: Text(price['commodityname']),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Vegetable',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      label: 'Available Quantity',
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildFormField(
                      label: 'Unit',
                      controller: _unitController,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _deliveryOption,
                onChanged: (value) {
                  setState(() {
                    _deliveryOption = value!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Available',
                    child: Text(' Available'),
                  ),
                  DropdownMenuItem(
                    value: 'Not Available',
                    child: Text('Not Available'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Do you deliver?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: _deliveryOption == 'Available',
                child: TextFormField(
                  controller: _deliveryDesController,
                  decoration: InputDecoration(
                    labelText: 'Delivery Description',
                    hintText: 'eg :within KTM valley or within 3km',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildFormField(
                label: 'ContactNumber',
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              _buildFormField(
                label: 'Location',
                controller: _locationController,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: handleLocationSelection,
                child: Text(
                  'Tap to choose location',
                  style: TextStyle(
                    color: Colors.green,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (_pickedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.file(
                    File(_pickedImage!.path),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Text('Select Image'),
              ),
              SizedBox(height: 10),
              _buildFormField(
                label: 'Description',
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String imageUrl = '';

                    {
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference refernceDirImages =
                          referenceRoot.child('ProductImages/');
                      Reference referenceImageUpload =
                          refernceDirImages.child(uniqueFileName + '.jpg');

                      try {
                        await referenceImageUpload.putFile(_pickedImage!);
                        imageUrl = await referenceImageUpload.getDownloadURL();
                        print('Image uploaded. URL: $imageUrl');
                      } catch (error) {
                        print('Error uploading image: $error');
                      }
                    }

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? userPhone = prefs.getString(MyAppState.PHONENUMBER);
                    String? sellerName = prefs.getString(MyAppState.NAME);
                    String name = _enteredName;
                    String phoneNumber = _phoneNumberController.text;
                    String location = _locationController.text;
                    String description = _descriptionController.text;
                    String price = _priceController.text;
                    String category = _selectedCategory;

                    // print('Name:'+_enteredName );
                    print('Price: ${_priceController.text}');
                    print('Description: ${_descriptionController.text}');
                    print('Latitude: $latitude1');
                    print('Longitude: $longitude1');
                    print('Location: ${_locationController.text}');
                    print('name is' + name);
                    print(_selectedCategory);
                    print(price);
                    print("hi i am deliverybot" +
                        _deliveryOption +
                        _unitController.text +
                        _quantityController.text);

                    AddItemDTO additemdto = AddItemDTO(
                        productImage: imageUrl,
                        category: category,
                        description: description,
                        latitude: latitude1,
                        longitude: longitude1,
                        location: location,
                        name: name,
                        phonenumber: phoneNumber,
                        usernamePh: userPhone,
                        price: price,
                        sellerName: sellerName,
                        availableQuantity:int.tryParse( _quantityController.text),
                        deliveryDescrip:_deliveryDesController.text ,
                        deliveryOption: _deliveryOption,
                        unit: _unitController.text,
                      );
                    Apiservice apiservice = ApiserviceImpl();
                 await apiservice.addProduct(additemdto);
                    populateProductsFromAPI();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    int? maxLines,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged(value);
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          // Add your validation logic here
          return null;
        },
      ),
    );
  }
}
