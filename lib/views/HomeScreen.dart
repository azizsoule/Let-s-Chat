
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/views/ConnexionScreen.dart';
import 'package:lets_chat/views/InscriptionScreen.dart';
import 'package:lets_chat/widgets/AlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {

   @override
   _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final Color themeColor = Colors.black;

   int index = 0;

   Widget Body(int index) {
      switch (index) {
         case 0:
            return ConnexionScreen();
            break;

         case 1:
            return InscriptionScreen();
            break;

         default:
            print("error");
            return null;
      }
   }

   @override
   Widget build(BuildContext context) {
      return Scaffold(
         appBar: AppBar(
            backgroundColor: themeColor,
            title: Text("Let's Chat",style: TextStyle(fontWeight: FontWeight.bold),),
            centerTitle: true,
         ),

         bottomNavigationBar: BottomNavigationBar(
            backgroundColor: themeColor,
            showUnselectedLabels: false,
            currentIndex: index,
            onTap: (id) {
               index = id;
               setState(() {

               });
            },
            items: <BottomNavigationBarItem> [

               BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person,color: Colors.white,),
                  title: Text("Connexion",style: TextStyle(color: Colors.white),),
               ),

               BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_add,color: Colors.white),
                  title: Text("Inscription",style: TextStyle(color: Colors.white)),
               )

            ],
         ),

         body: Body(index),

      );
   }
}