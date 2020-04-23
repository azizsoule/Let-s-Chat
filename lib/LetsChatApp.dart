import 'package:flutter/material.dart';
import 'package:lets_chat/views/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/views/ConnectedUserHomeScreen.dart';


class LetsChatApp extends StatefulWidget {

  @override
  _LetsChatAppState createState() => _LetsChatAppState();
}

class _LetsChatAppState extends State<LetsChatApp> {

  String user;

  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      this.user = (sharedPrefs.getString('user') ?? null);
    });
  }


  @override
  Widget build(BuildContext context) {

     if (this.user == null) {
        return MaterialApp(
           debugShowCheckedModeBanner: false,
           home: HomeScreen(),
           title: "Let's Chat",
           theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Color(0xff0378e5),
              fontFamily: 'Nunito'
           ),
        );
     } else {
        return MaterialApp(
           debugShowCheckedModeBanner: false,
           home: ConnectedUserHomeScreen(
             pseudo: this.user,
           ),
           title: "Let's Chat",
           theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Color(0xff0378e5),
              fontFamily: 'Nunito'
           ),
        );
     }

  }
}
