import 'dart:io';

import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/main.dart';
import 'package:final_year_project/data/product_data.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/model/signupdata.dart';
import 'package:final_year_project/views/additemForm.dart';
import 'package:final_year_project/views/loginscreen.dart';
import 'package:final_year_project/views/myitems.dart';
import 'package:final_year_project/model/product.dart';
import 'package:final_year_project/views/orders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userProfile = '';
  String userName = '';
  String userEmail = '';
  String? phonenumber ='';
  int id = 0; // Declare a variable to store the user profile URL

  void fetch() async {
     
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userProfile = prefs.getString(MyAppState.USERPROFILE) ?? '';
      userName = prefs.getString(MyAppState.NAME) ?? '';
      userEmail = prefs.getString(MyAppState.EMAIL) ?? '';
      phonenumber = prefs.getString(MyAppState.PHONENUMBER);
      //  id = int.parse(prefs.getString(MyAppState.ID) ?? '');

     
    });
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 15),
              child: CircleAvatar(
                radius: 62.0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: _buildProfilePicture(),
              ),
            ),
            Center(
              child: Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Center(
              child: Text(
                userEmail,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 25),
             ListTile(
              title: Text("Orders"),
              leading: Icon(IconlyLight.buy),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersPage(contact: phonenumber!),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Add Items"),
              leading: Icon(IconlyLight.upload),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemForm(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("My Items"),
              leading: Icon(IconlyLight.bag2),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyItems(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Edit Profile"),
              leading: Icon(IconlyLight.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditProfileDialog(
                      userEmail: userEmail,
                      onUpdate: (newEmail) {
                        setState(() {
                          userEmail = newEmail;
                        });
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(IconlyLight.logout),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) =>
                                  false, // Remove all routes until the login screen
                            );
                          },
                          child: Text("Logout"),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 60,
      backgroundImage: NetworkImage(userProfile),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final String userEmail;
  final ValueChanged<String> onUpdate;

  const EditProfileDialog({
    Key? key,
    required this.userEmail,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  File? _pickedImage;
  late String _newEmail;

  @override
  void initState() {
    super.initState();
    _newEmail = widget.userEmail;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Profile"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_pickedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.file(
                  _pickedImage!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              child: Text('Select Image'),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.userEmail,
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) => _newEmail = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String imageUrl = '';

            {
              String uniqueFileName =
                  DateTime.now().millisecondsSinceEpoch.toString();

              // Reference to the storage root
              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference refernceDirImages = referenceRoot.child('Images/');

              Reference referenceImageUpload =
                  refernceDirImages.child(uniqueFileName + '.jpg');

              try {
                await referenceImageUpload.putFile(_pickedImage!);
                imageUrl = await referenceImageUpload.getDownloadURL();
                print('Image uploaded. URL: $imageUrl');
              } catch (error) {
                print('Error uploading image: $error');
              }
              print('new image is' + imageUrl);
              SharedPreferences preffs = await SharedPreferences.getInstance();
              preffs.setString(MyAppState.USERPROFILE, imageUrl);
              SignupData update =
                  SignupData(userProfile: imageUrl, email: _newEmail);
              Apiservice apis = ApiserviceImpl();
              await apis.updateUser(update);
            }
            Navigator.of(context).pop();
            
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
