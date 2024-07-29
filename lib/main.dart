import 'package:flutter/material.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'splash_screen.dart'; // Import the splash screen
import 'about_us_page.dart'; // Import the About Us page
import 'item.dart';
import 'dart:io';
import 'home.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget{

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print("initState called");  // Debug print
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(), // Set the splash screen as the home
      routes: {
        '/home': (context) => Home(),
        '/register': (context) => RegistrationPage(),
        '/login': (context) => LoginPage(),
        '/about': (context) => AboutUsPage(), // Define the route for AboutUsPage
      },
    );
  }
}
