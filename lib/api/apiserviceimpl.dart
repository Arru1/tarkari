import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/main.dart';
import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/model/fcmtoken.dart';
import 'package:final_year_project/model/signupdata.dart';
import 'package:final_year_project/model/transaction.dart';
import 'package:final_year_project/util/constant.dart';
import 'package:final_year_project/util/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiserviceImpl implements Apiservice
{
  Dio dio = Dio();
  bool success=false;
  String token='';
  @override
  //signupwala API
  Future<bool> saveUsers(SignupData signupdata) async {
    print('apicallfunction is this ${signupdata.userProfile}');
    bool isConnectionAvailable = await Helper.checkInternetConnection();
    if (isConnectionAvailable) {
      try {
        Response response = await dio.post("${MasterClass.baseUrl}addNewUser",
            data: signupdata.toJson());
        if (response.statusCode == 200 || response.statusCode == 201) {
          // userId = response.data;
          // print(userId);
          success = true;
        }
      } catch (e) {
        print(e);
      }
      return success;
    }
    return success;
  }
  //loginwalaAPI
  @override
Future<String> loginUser(SignupData logindata) async {
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      Response response = await dio.post(
        "${MasterClass.baseUrl}generateToken",
        data: logindata.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
         token = response.data; 
        print("JWT Token: $token");
        return token;
      }
    } catch (e) {
      print(e);
    }
    return token;
  }
  return token;
}
//fetchUserData
  @override
  Future<SignupData?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      String? bearerToken = prefs.getString(MyAppState.TOKEN);
      String? phoneNumber = prefs.getString(MyAppState.PHONENUMBER);
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}user/userInfo/$phoneNumber",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
       return SignupData.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
  }
//AddProductAPI
  @override
  Future<bool> addProduct(AddItemDTO additemdto)async {
   bool isConnectionAvailable = await Helper.checkInternetConnection();
   SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnectionAvailable) {
      try {
        String? bearerToken = prefs.getString(MyAppState.TOKEN);
        dio.options.headers['Authorization']='Bearer $bearerToken';
        dio.options.headers['Content-Type']='application/json';
        Response response = await dio.post("${MasterClass.baseUrl}addProduct",
            data: additemdto.toJson());
        if (response.statusCode == 200 || response.statusCode == 201) {
          
          success = true;
          print("hello your product is uploaded");
        }
      } catch (e) {
        print(e);
      }
      return success;
    }
    return success;
  }

  //fetchProductData
 @override
Future<List<AddItemDTO>?> fetchProduct() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      String? bearerToken = prefs.getString(MyAppState.TOKEN);
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}product/fetchProducts",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming your API response is a list of items
        List<dynamic> responseData = response.data;
        List<AddItemDTO> itemList = responseData
            .map((itemJson) => AddItemDTO.fromJson(itemJson))
            .toList();
        return itemList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
}

  @override
  Future<bool> updateProduct(AddItemDTO additemdto, int? id) async {
     bool isConnectionAvailable = await Helper.checkInternetConnection();
   SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnectionAvailable) {
      try {
        print('the upload id is{id}');
        String? bearerToken = prefs.getString(MyAppState.TOKEN);
        dio.options.headers['Authorization']='Bearer $bearerToken';
        dio.options.headers['Content-Type']='application/json';
        Response response = await dio.put("${MasterClass.baseUrl}updateProduct/$id",
            data: additemdto.toJson());
        if (response.statusCode == 200 || response.statusCode == 201) {
          
          success = true;
          print("hello your product is updated");
        }
      } catch (e) {
        print(e);
      }
      return success;
    }
    return success;
    
  }
  
  @override
  Future<bool> deleteProduct(int? id) async{
bool isConnectionAvailable = await Helper.checkInternetConnection();
   SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnectionAvailable) {
      try {
        String? bearerToken = prefs.getString(MyAppState.TOKEN);
        dio.options.headers['Authorization']='Bearer $bearerToken';
        print("id here in apicall is +$id");
        print(bearerToken);
        Response response = await dio.delete("${MasterClass.baseUrl}product/deleteProduct/$id");
        if (response.statusCode == 200 || response.statusCode == 201) {
          
          success = true;
          print("hello your product is deleted");
        }
      } catch (e) {
        print(e);
        print("unable to delete");
      }
      return success;
    }
    return success;
    
  }
  
  @override
  Future<bool> updateUser(SignupData signupData)async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      String? bearerToken = prefs.getString(MyAppState.TOKEN);
      String? phoneNumber = prefs.getString(MyAppState.PHONENUMBER);
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.put(
        "${MasterClass.baseUrl}user/updateUser/$phoneNumber",
        data: signupData.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('update sucessful of profile');
       return (response.data);
       
      }
    } catch (e) {
      print(e);
    }
    return success;
  }
  return success;
  }
  
  @override
  Future<List<AddItemDTO>?> adminFetchProduct() async {
     bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}fz/admin/product/fetchProducts",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming your API response is a list of items
        List<dynamic> responseData = response.data;
        List<AddItemDTO> itemList = responseData
            .map((itemJson) => AddItemDTO.fromJson(itemJson))
            .toList();
        return itemList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;

  }
  
  @override
  Future<List<SignupData>?> adminFetchUsers() async{
    bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}fz/admin/user/fetchAllUsers",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming your API response is a list of items
        List<dynamic> responseData = response.data;
        List<SignupData> itemList = responseData
            .map((itemJson) => SignupData.fromJson(itemJson))
            .toList();
        return itemList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
  }

  @override
  Future<bool> addTransaction(Transaction transaction, int? id) async{
    print('begining transaction...');
  bool isConnectionAvailable = await Helper.checkInternetConnection();
   SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnectionAvailable) {
      try {
        String? bearerToken = prefs.getString(MyAppState.TOKEN);
        dio.options.headers['Authorization']='Bearer $bearerToken';
        dio.options.headers['Content-Type']='application/json';
        Response response = await dio.post("${MasterClass.baseUrl}addTransaction/$id",
            data: transaction.toJson());
        if (response.statusCode == 200 || response.statusCode == 201) {
          
          success = true;
          print(
            " sucessful transaction ok ok ok");
        }
      } catch (e) {
        print(e);
      }
      return success;
    }
    return success;
  }
  
  @override
  Future<List<Transaction>?> getTransactionSelled(Transaction transaction) async {
    int id = 2;
  print('reached in fetching products seller');
SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      String? bearerToken = prefs.getString(MyAppState.TOKEN);
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}getTransaction/$id",data: transaction.toJson()
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming your API response is a list of items
        List<dynamic> responseData = response.data;
        List<Transaction> itemList = responseData
            .map((itemJson) => Transaction.fromJson(itemJson))
            .toList();
        return itemList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
  }
 @override
  Future<List<Transaction>?> getTransactionBought(Transaction transaction) async {
  print('reached in buyer');
  int id=1;
SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      String? bearerToken = prefs.getString(MyAppState.TOKEN);
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}getTransaction/$id",data: transaction.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming your API response is a list of items
        List<dynamic> responseData = response.data;
        List<Transaction> itemList = responseData
            .map((itemJson) => Transaction.fromJson(itemJson))
            .toList();
        return itemList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
  }
  
  @override
  Future<bool> deleteProductAdmin(int? id) async {
  
bool isConnectionAvailable = await Helper.checkInternetConnection();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnectionAvailable) {
      try {
        //String? bearerToken = prefs.getString(MyAppState.TOKEN);
      // print("id here in apicall is +$id");
      //  print(bearerToken);
        Response response = await dio.delete("${MasterClass.baseUrl}fz/admin/deleteProduct/$id");
        if (response.statusCode == 200 || response.statusCode == 201) {
          
          success = true;
          print("hello admin product is deleted");
        }
      } catch (e) {
        print(e);
        print("unable to delete");
      }
      return success;
    }
    return success;
    
  }
  
  @override
  Future<List<AddItemDTO>?> fetchMyProducts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      String? bearerToken = prefs.getString(MyAppState.TOKEN);
      String? phonenumber = prefs.getString(MyAppState.PHONENUMBER);
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}product/fetchMyProducts/${phonenumber}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
     
        List<dynamic> responseData = response.data;
        List<AddItemDTO> itemList = responseData
            .map((itemJson) => AddItemDTO.fromJson(itemJson))
            .toList();
        return itemList;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
  }
  
  @override
  Future<SignupData?> forgotPassword(String username) async{
     bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}user/passwordRecover/${'+977$username'}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
       return SignupData();
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
  }
  
  @override
  Future<bool?> changePassword(SignupData signupData) async{
    bool? succ= false;
 bool isConnectionAvailable = await Helper.checkInternetConnection();
    if (isConnectionAvailable) {
      try {
        Response response = await dio.put("${MasterClass.baseUrl}user/updatePasswordOtp",
            data: signupData.toJson());
        if (response.statusCode == 200 || response.statusCode == 201) {
          // userId = response.data;
          // print(userId);
          succ = true;
        }
      } catch (e) {
        print(e);
      }
      return succ;
    }
    return succ;
  }

  @override
  Future<FcmToken?> getFcmToken(String phonenumber)async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isConnectionAvailable = await Helper.checkInternetConnection();
  if (isConnectionAvailable) {
    try {
      String? bearerToken = prefs.getString(MyAppState.TOKEN);
   
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
      Response response = await dio.get(
        "${MasterClass.baseUrl}getFcmToken$phonenumber",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
       return FcmToken.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  return null;
  
  }

  @override
  Future<bool> saveFcmToken(FcmToken fcmtoken) async {
    bool isConnectionAvailable = await Helper.checkInternetConnection();
      SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isConnectionAvailable) {
      try {
        String? bearerToken = prefs.getString(MyAppState.TOKEN);
   
      dio.options.headers['Authorization']='Bearer $bearerToken';
      dio.options.headers['Content-Type']='application/json';
        Response response = await dio.post("${MasterClass.baseUrl}saveFcmToken",
            data: fcmtoken.toJson());
        if (response.statusCode == 200 || response.statusCode == 201) {
          
          success = true;
        }
      } catch (e) {
        print(e);
      }
      return success;
    }
    return success;
  }
  
}