
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/views/ConnexionScreen.dart';
import 'package:lets_chat/views/InscriptionScreen.dart';
import 'package:lets_chat/style/style.dart';

class HomeScreen extends StatefulWidget {

   @override
   _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
         backgroundColor: background,
         bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: false,
            currentIndex: index,
            onTap: (id) {
               index = id;
               setState(() {

               });
            },
            items: <BottomNavigationBarItem> [

               BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person,color: textColor,),
                  title: Text("Connexion",style: TextStyle(color: textColor),),
               ),

               BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_add,color: textColor),
                  title: Text("Inscription",style: TextStyle(color: textColor)),
               )

            ],
         ),

         body: SafeArea(
           child: Column(
             children: <Widget>[
                Container(
                   padding: EdgeInsets.all(30),
                   decoration: BoxDecoration(
                      boxShadow:softShadows
                   ),
                   child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         Center(
                           child: Text(
                              "Let's Chat",
                              style: TextStyle(
                                 color: textColor,
                                 fontSize: 25,
                                 fontWeight: FontWeight.bold),
                           ),
                         ),
                      ],
                   ),
                ),

               Expanded(child: Body(index)),
             ],
           ),
         ),

      );
   }
}