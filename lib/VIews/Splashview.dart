import 'package:beathub/VIews/Loginview.dart';
import 'package:flutter/material.dart';

class Splashview extends StatefulWidget {
  @override
  _SplashviewState createState() => _SplashviewState();
}

class _SplashviewState extends State<Splashview> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('Assets/Images/logowhite.jpeg'),
        ],
      ),
    );
  }
}
