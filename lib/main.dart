
import 'package:final_year_project/firebase_options.dart';
import 'package:final_year_project/services/notificationhandling.dart';
import 'package:final_year_project/views/admindashboard.dart';
import 'package:final_year_project/views/explore.dart';
import 'package:final_year_project/views/firebase.dart';
import 'package:final_year_project/views/footer.dart';
import 'package:final_year_project/views/loginscreen.dart';
import 'package:final_year_project/views/map.dart';
import 'package:final_year_project/views/mapforprodet.dart';
import 'package:final_year_project/views/market.dart';
import 'package:final_year_project/views/oldOrder.dart';
import 'package:final_year_project/views/oldOrderDetails.dart';
import 'package:final_year_project/views/otpscreen.dart';
import 'package:final_year_project/views/sign_up.dart';
import 'package:final_year_project/views/vegeprice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  NotificationService notificationService = NotificationService();
   notificationService.initialize();

  // Set the background message handler
  //FirebaseMessaging.onBackgroundMessage(notificationService.handleBackgroundMessage);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
    final NotificationService notificationService = NotificationService();
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static const String KEYLOGIN = 'keylogin';
  static const String PHONENUMBER = 'phonenumber';
  static const String EMAIL = 'email';
  static const String USERPROFILE = 'userprofile';
  static const String TOKEN ='token';
  static const String NAME='name';
 // static const String ID ='id';
  bool isLoggedin = false;
 @override
  void initState() {

    check();
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: 'test_public_key_d577b97ec4b54691a1abfeef62a5218e',
      builder: (context, navigatorKey) {
      return MaterialApp(
          navigatorKey: navigatorKey,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ne', 'NP'),
      ],
      localizationsDelegates: const [
        KhaltiLocalizations.delegate,
        
      ],
        title: 'FarmerZone',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
      //home:SignUpPage(),
        //home:OTPVerificationScreen(),
    home:isLoggedin?Footer(): LoginScreen(),
     // home:OrderDetailsPage(),
      //home:ExplorePage(),
      //home: Footer(),
      //  home:MarketPage(),
      //home:DailyPricesTable(),
     // home:LoginScreen(),
    //home: AddItemPage(),
    //home:MapScreen(),
    //home: TestForm(),
    //home:MapScreenProduct(  latitude: 27.63, longitude: 85.52,sellername:'aakash'),
    //home: HomeScreen(),
   // home:LoginScreen(),
    );  
  } ,
      );
    
  }
  
  void check() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedin = prefs.getBool(MyAppState.KEYLOGIN)?? false;
    });
    print(prefs.getString(MyAppState.TOKEN));
    
    print("reached");
    _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmtoken = await _firebaseMessaging.getToken();
    print("the fcm token is ${fcmtoken}");
  
  }
}
