import 'dart:async';
import 'package:lets_chat/LetsChatApp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/views/AlertDialog.dart';
import 'package:lets_chat/views/SettingScreen.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();

  String userPseudo;
  BuildContext context;

  UserDrawer( this.userPseudo, this.context);
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          child: Image.asset(
            'assets/images/profil.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: Firestore.instance.collection("comptes").document(widget.userPseudo).snapshots(),
              builder: (context, snapshot) {

                if(!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Drawer(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              DrawerItems("Pseudo", 'pseudo', snapshot.data),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              DrawerItems("Nom", 'nom', snapshot.data),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              DrawerItems("Prenoms", 'prenoms', snapshot.data),
                            ],
                          ),

                          Row(
                            children: <Widget>[
                              DrawerItems("Password", 'password', snapshot.data),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.clear_circled,color: Colors.black,size: 30,),
              tooltip: "Deconnexion",
              onPressed: () {
                deconnexion(context,widget.userPseudo);
              },
            ),

            IconButton(
              tooltip: "Parametres",
              icon: Icon(CupertinoIcons.settings,color: Colors.black,size: 30,),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SettingScreen();
                  })
                );
              },
            ),
          ],
        )
      ],
    );
  }

  Widget DrawerItems(String title,String key,DocumentSnapshot data)  {

    var password = "";

    for(int i= 0; i<data['password'].length;i++) {
      password = password + "*";
    }

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 20,left: 20,right: 20),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text(password, style: TextStyle(fontSize: 15,color: Colors.grey),)
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)
        ),
      ),
    );
  }

  deconnexion (BuildContext context, String pseudo) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('userPseudo', "");
    Firestore.instance.collection("comptes").document(pseudo).updateData({"connected": false});
    Navigator.pop(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) {
              return LetsChatApp();
            }
        ),
        ModalRoute.withName(""));
  }

}