import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/model/signupdata.dart';
import 'package:final_year_project/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hello Admin'),
          actions: [
            IconButton(onPressed: (){
                Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) =>
                                  false, );
            }, icon: Icon(Icons.logout)),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Products'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserList(),
            ProductList(),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final Apiservice apis = ApiserviceImpl(); // Instance of ApiService
  late Future<List<SignupData>?> users; // Future for fetching users

  UserList() {
    users = fetchUsers(); // Initialize users in the constructor
  }

  Future<List<SignupData>?> fetchUsers() async {
    try {
      return await apis.adminFetchUsers(); // Fetch users from API
    } catch (e) {
      print('Error fetching users: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SignupData>?>(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<SignupData>? userList = snapshot.data;
          return ListView.builder(
            itemCount: userList!.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDetailsPage(user: user)),
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  leading: Image(
                     image: NetworkImage(user.userProfile!), fit: BoxFit.cover,
                   ),
                  title: Text(user.name!),
                  // trailing: IconButton(
                  //   icon: Icon(Icons.delete),
                  //   onPressed: () {
                  //     // Add your delete functionality here
                  //   },
                  // ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}

class ProductList extends StatelessWidget {
  final Apiservice apis = ApiserviceImpl(); // Instance of ApiService
  late Future<List<AddItemDTO>?> products; // Future for fetching products

  ProductList() {
    products = fetchProducts(); // Initialize products in the constructor
  }

  Future<List<AddItemDTO>?> fetchProducts() async {
    try {
      return await apis.adminFetchProduct(); // Fetch products from API
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

   @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AddItemDTO>?>(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<AddItemDTO>? productList = snapshot.data;
          return ListView.builder(
            itemCount: productList!.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetailsPageAdmin(product: product,)),
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.green,
                    child: Image(
                      image: NetworkImage(product.productImage!), fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(product.name!), 
                  subtitle: Text(product.description!), 
                  // trailing: IconButton(
                  //   icon: Icon(Icons.view_agenda),
                  //   onPressed: () {
                  //     // Add your delete functionality here
                  //   },
                  // ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}


class UserDetailsPage extends StatelessWidget {
  final SignupData user;

  const UserDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 100,width: 100,
                child: Image(
                     image: NetworkImage(user.userProfile!), fit: BoxFit.cover,
                   ),
              ),
              SizedBox(height: 20),
              Text(
                user.name!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Email: ${user.email}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Phone: ${user.username}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Id: ${user.id
                }',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailsPageAdmin extends StatefulWidget {
  final AddItemDTO product;

  const ProductDetailsPageAdmin({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageAdminState createState() => _ProductDetailsPageAdminState();
}

class _ProductDetailsPageAdminState extends State<ProductDetailsPageAdmin> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Image(
                  image: NetworkImage(widget.product.productImage ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(widget.product.name ?? ''),
              subtitle: Text(widget.product.description ?? ''),
            ),
            ListTile(
              title: Text('Location'),
              subtitle: Text(widget.product.location ?? ''),
            ),
            ListTile(
              title: Text('Seller'),
              subtitle: Text(widget.product.sellerName ?? ''),
            ),
            ListTile(
              title: Text('Price'),
              subtitle: Text(widget.product.price ?? ''),
            ),
            ListTile(
              title: Text('Delivery Option'),
              subtitle: Text(widget.product.deliveryOption ?? ''),
            ),
            ListTile(
              title: Text('Delivery Description'),
              subtitle: Text(widget.product.deliveryDescrip ?? ''),
            ),
            ListTile(
              title: Text('Contact'),
              subtitle: Text(widget.product.usernamePh ?? ''),
            ),
            ListTile(
              title: Text('Latitude'),
              subtitle: Text(widget.product.latitude.toString()),
            ),
            ListTile(
              title: Text('Longitude'),
              subtitle: Text(widget.product.longitude.toString()),
            ),
            ListTile(
              title: Text('Available Quantity'),
              subtitle: Text(widget.product.availableQuantity.toString()),
            ),
            ListTile(
              title: Text('Phone Number'),
              subtitle: Text(widget.product.phonenumber!),
            ),
            ListTile(
              title: Text('Category'),
              subtitle: Text(widget.product.category!),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                setState(() {
                  _isLoading = true;
                });
                // Call your API service to delete the product
                try {
               Apiservice apiService = ApiserviceImpl();
                  await apiService.deleteProductAdmin(widget.product.id);
                  ProductList fet = ProductList();
                  await fet.fetchProducts();
                //  products.removeWhere((product) => product.id == 2);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product deleted successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Pop the current page after deletion
                  Navigator.pop(context);
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete product'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: _isLoading ? CircularProgressIndicator() : Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}