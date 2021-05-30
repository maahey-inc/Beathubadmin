import 'dart:io';
import 'dart:ui';

import 'package:beathub/VIews/AdminHomeView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final email = new TextEditingController();
  final password = new TextEditingController();
  final firebase = FirebaseFirestore.instance;
  login() async {
    print("logging");
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: CoolAlertType.loading,
      text: "Logging You In!",
    );
    firebase
        .collection("admin")
        .where("email", isEqualTo: email.text)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        print("Email incorrect");
        Navigator.pop(context);
        CoolAlert.show(
          barrierDismissible: false,
          context: context,
          type: CoolAlertType.error,
          text: "Email or Password not Correct",
        );
      } else {
        if (value.docs[0]["password"] != password.text) {
          Navigator.pop(context);
          print("Password incorrect");
          CoolAlert.show(
            barrierDismissible: false,
            context: context,
            type: CoolAlertType.error,
            text: "Email or Password not Correct",
          );
        } else {
          final user = FirebaseAuth.instance.signInAnonymously();
          if (user != null) {
            //prefs.setString("type", "admin");
            print("success");
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHomeView(),
              ),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("Assets/Images/dj.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                color: Color(0xFF000000).withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    bottom: 10,
                    right: 40,
                    left: 40,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          'Assets/Images/logotransparent.png',
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Textfield(
                          password: false,
                          hinttext: "Email",
                          controller: email,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Textfield(
                          password: true,
                          hinttext: "Password",
                          controller: password,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              login();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'LOG IN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Textfield extends StatelessWidget {
  bool password;
  TextEditingController controller;
  String hinttext;
  Textfield({
    this.controller,
    this.password,
    this.hinttext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: TextField(
            controller: controller,
            obscureText: password,
            //obscureText: true,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: hinttext,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
