import 'dart:async';
import 'package:lets_chat/LetsChatApp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/AlertDialog/AlertDialog.dart';

Widget UserDrawer(String userPseudo) {
  return StreamBuilder(
      stream: Firestore.instance.collection("comptes").document(userPseudo).snapshots(),
      builder: (context, snapshot) {

        if(!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: Image.asset(
                  'assets/images/profil.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(CupertinoIcons.clear_circled,color: Colors.black,size: 30,),
                    tooltip: "Deconnexion",
                    onPressed: () {
                      deconnexion () async{
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setString('userPseudo', "");

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) {
                                  return LetsChatApp();
                                }
                            ),
                            ModalRoute.withName(""));
                      }

                      deconnexion();
                    },
                  ),

                  IconButton(
                    tooltip: "Parametres",
                    icon: Icon(CupertinoIcons.settings,color: Colors.black,size: 30,),
                    onPressed: () {

                    },
                  ),
                ],
              )
            ],
          ),
        );
      }
  );
}

Widget DrawerItems(String title,String key,DocumentSnapshot data)  {
  return Expanded(
    child: Container(
      margin: EdgeInsets.only(top: 20,left: 20,right: 20),
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          Text(data[key], style: TextStyle(fontSize: 15,color: Colors.grey),)
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)
      ),
    ),
  );
}