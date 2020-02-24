import 'package:flutter/material.dart';
import 'package:lets_chat/HomeScreen.dart';

class LetsChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      title: "Let's Chat",
    );
  }
}