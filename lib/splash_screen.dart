import 'package:flutter/material.dart';
import 'home.dart'; // Import your Home screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Home screen after a delay
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Red background for the splash screen
      body: Center(
        child: Image.asset(
          'assets/cropped-hiperao.png',
          height:200,
          width: 200,
        ),
      ),
    );
  }
}
