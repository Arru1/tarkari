import 'package:internet_connection_checker/internet_connection_checker.dart';

class Helper {
  static checkInternetConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }} 