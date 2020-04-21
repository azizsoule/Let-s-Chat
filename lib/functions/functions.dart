import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences pref;

dynamic getFuture(Future<dynamic> future) async {
   var value = await future;
   return value;
}

Future<bool> docExist(String doc) async{

   final fireStoreConnector = Firestore.instance;

   DocumentSnapshot ds = await fireStoreConnector.collection("comptes").document(doc).get();

   return ds.exists;
}

void register(String pseudo, String nom, String prenoms, String password, String confPass,BuildContext context) async {

   final fireStoreConnector = Firestore.instance;

   final Map<String,dynamic> data = {"pseudo":pseudo,"nom":nom,"prenoms":prenoms,"password":password,"connected": false};

   await fireStoreConnector.collection("comptes")
      .document(pseudo)
      .setData(data);

}