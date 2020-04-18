import 'package:flutter/material.dart';
import 'package:lets_chat/widgets/PersonalButon.dart';
import 'package:lets_chat/widgets/PersonnalInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/views/AlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/views/ConnectedUserHomeScreen.dart';



// ignore: must_be_immutable
class ConnexionScreen extends StatelessWidget {

  static const Color themeColor = Colors.black;

  PersonalInput pseudo = new PersonalInput(hinText: "Pseudo", color: themeColor,control: new TextEditingController(),icon: Icon(CupertinoIcons.person),);

  PersonalInput password = new PersonalInput(hinText: "Password", color: themeColor,control: new TextEditingController(),icon: Icon(CupertinoIcons.padlock),obscur: true,isPassWordField: true,);

  SharedPreferences preference;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 80,left: 50,right: 50,bottom: 80),
        child: Column(
          children: <Widget>[
            Text("LOGIN",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color: themeColor), ),
            SizedBox(height: 50),
            pseudo,
            SizedBox(height: 50,),
            password,
            SizedBox(height: 50,),
            PersonalButton(text :"Connexion",buttonColor: themeColor,textSize: 25,paddingl: 70, paddingr: 70,paddingt: 15,paddingb: 15 ,radius: 10,onClick: () {
              loadingAlertDialog(context, "Connexion ...");
              this.check(this.pseudo.getControllerText,this.password.getControllerText,context);
            },)
          ],
        ),
      ),
    );
  }


  void check(String pseudo, String password, BuildContext context) {
    if(pseudo.isEmpty || password.isEmpty) {
      Navigator.of(context).pop();
      showAlertDialog(context, "Veuillez remplir tous les champs !!!");
    }else {

      Future<bool> result = docExist(pseudo);

      result.then((value) {

        if(value == true) {
          testPassword(pseudo, password,context);
        }else {
          Navigator.of(context).pop();
          showAlertDialog(context, "Ce compte n'existe pas . veuillez vous inscrire !");
        }

      },

      onError: (error) {
        Navigator.of(context).pop();
        showAlertDialog(context, "Verifiez votre connexion internet !");
      }

      );
  }
  }


  Future<bool> docExist(String doc) async{

    final fireStoreConnector = Firestore.instance;

    DocumentSnapshot ds = await fireStoreConnector.collection("comptes").document(doc).get();

    return ds.exists;
  }


  void testPassword(String pseudo, String password,BuildContext context) {

    String pass;

    final fireStoreConnector = Firestore.instance;

    fireStoreConnector
        .collection("comptes")
        .document(pseudo)
        .get()
        .then((value) {
          pass = value.data['password'];

          if (pass == password) {
            Navigator.of(context).pop();
            saveUser(pseudo);
            //showAlertDialog(context, "connexion reussie");

            fireStoreConnector.collection('comptes').document(pseudo).updateData({"connected":true});

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) {
                    return ConnectedUserHomeScreen(pseudo: pseudo,);
                  }
                ),
                ModalRoute.withName(""));
          }else {
            Navigator.of(context).pop();
            showAlertDialog(context,"Pseudo ou mot de passe incorrect !");
          }
        }

    );

  }

  void saveUser(String pseudo) async {
    this.preference = await SharedPreferences.getInstance();
    this.preference.setString('userPseudo', pseudo);
  }
}