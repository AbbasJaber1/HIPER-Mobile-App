import 'package:flutter/material.dart';
import 'home.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'splash_screen.dart'; // Import the splash screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/register': (context) => RegistrationPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

