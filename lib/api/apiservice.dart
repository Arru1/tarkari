import 'package:final_year_project/model/additemmodel.dart';
import 'package:final_year_project/model/fcmtoken.dart';
import 'package:final_year_project/model/signupdata.dart';
import 'package:final_year_project/model/transaction.dart';

abstract class Apiservice{
  //signup garda kheri
  Future<bool> saveUsers(SignupData signupdata);
  //
  Future<String> loginUser(SignupData logindata);
  Future<SignupData?> getUserInfo();
  Future<bool> saveFcmToken(FcmToken fcmtoken);
  Future<FcmToken?> getFcmToken(String phonenumber);
  Future<SignupData?> forgotPassword(String username);
  Future<bool?> changePassword(SignupData signupData);
  Future<bool> addProduct(AddItemDTO additemdto);
    Future<List<AddItemDTO>?> fetchProduct();
    Future<bool> updateProduct(AddItemDTO additemdto ,int? id);
    Future<bool> deleteProduct(int? id);
    Future<bool> updateUser(SignupData signupData);
    Future<List<AddItemDTO>?> adminFetchProduct();
    Future<List<SignupData>?> adminFetchUsers();
    Future<bool> addTransaction(Transaction transaction, int? id);
    Future<List<Transaction>?> getTransactionSelled(Transaction transaction);
    Future<List<Transaction>?> getTransactionBought(Transaction transaction);
    Future<bool> deleteProductAdmin(int? id);
   Future<List<AddItemDTO>?> fetchMyProducts();


}