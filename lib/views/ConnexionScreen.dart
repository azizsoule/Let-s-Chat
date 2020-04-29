import 'package:flutter/material.dart';
import 'package:lets_chat/widgets/PersonalButon.dart';
import 'package:lets_chat/widgets/PersonnalInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/widgets/AlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/views/ConnectedUserHomeScreen.dart';
import 'dart:io';
import 'package:lets_chat/functions/functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: must_be_immutable
class ConnexionScreen extends StatelessWidget {
  static const Color themeColor = Colors.black;

  PersonalInput pseudo = new PersonalInput(
    hinText: "Pseudo",
    color: themeColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.person),
  );

  PersonalInput password = new PersonalInput(
    hinText: "Password",
    color: themeColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.padlock),
    obscur: true,
    isPassWordField: true,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(top: 80, left: 50, right: 50, bottom: 80),
        child: Column(
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(
                  fontSize: 40, fontWeight: FontWeight.bold, color: themeColor),
            ),
            SizedBox(height: 50),
            pseudo,
            SizedBox(
              height: 50,
            ),
            password,
            SizedBox(
              height: 50,
            ),
            PersonalButton(
              text: "Connexion",
              buttonColor: themeColor,
              textSize: 25,
              paddingl: 70,
              paddingr: 70,
              paddingt: 15,
              paddingb: 15,
              radius: 10,
              onClick: () async {
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    this.check(this.pseudo.getControllerText,
                        this.password.getControllerText, context);
                  }
                } on SocketException catch (_) {
                  showAlertDialog(context,
                      "Veuillez véeifier votre connexion à internet !!!");
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> check(
      String pseudo, String password, BuildContext context) async {
    if (pseudo.isEmpty || password.isEmpty) {
      showAlertDialog(context, "Veuillez remplir tous les champs !!!");
    } else {
      loadingAlertDialog(context, "Connexion ...");

      var result = await getFuture(docExist(pseudo));

      if (result == true) {
        testPassword(pseudo, password, context);
      } else {
        Navigator.of(context).pop();
        showAlertDialog(
            context, "Ce compte n'existe pas . veuillez vous inscrire !");
      }
    }
  }

  void testPassword(
      String pseudo, String password, BuildContext context) async {
    final fireStoreConnector = Firestore.instance;

    var result = await getFuture(
        fireStoreConnector.collection("comptes").document(pseudo).get());

    var pass = result.data['password'];

    if (pass == password) {
      Navigator.of(context).pop();
      saveUser(pseudo);
      //showAlertDialog(context, "connexion reussie");

      fireStoreConnector
          .collection('comptes')
          .document(pseudo)
          .updateData({"connected": true});

      await FirebaseMessaging().getToken().then((token) {
        fireStoreConnector
           .collection('comptes')
           .document(pseudo)
           .updateData({"token": token});
      });

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return ConnectedUserHomeScreen(
          pseudo: pseudo,
        );
      }), ModalRoute.withName(""));
    } else {
      Navigator.of(context).pop();
      showAlertDialog(context, "Pseudo ou mot de passe incorrect !");
    }
  }

  void saveUser(String pseudo) async {
    pref = await getFuture(SharedPreferences.getInstance());
    pref.setString('user', pseudo);
  }
}
