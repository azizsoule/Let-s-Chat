
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/views/ConnexionScreen.dart';
import 'package:lets_chat/views/InscriptionScreen.dart';

class HomeScreen extends StatelessWidget {

  final Color themeColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themeColor,
          title: Text("Let's Chat",style: TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            isScrollable: true,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold
            ),
            //indicator: De,
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(CupertinoIcons.person),
                    SizedBox(width: 5,),
                    Text("LOGIN")
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(CupertinoIcons.add_circled),
                    SizedBox(width: 5,),
                    Text("INSCRIPTION")
                  ],
                ),
              )
            ],
          ),

        ),
        body: TabBarView(
          children: <Widget>[
            ConnexionScreen(),
            InscriptionScreen()
          ],
        ),

      ),
    );
  }
}