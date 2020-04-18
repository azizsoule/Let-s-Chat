import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lets_chat/widgets/PersonalButon.dart';
import 'package:lets_chat/widgets/PersonnalInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/views/AlertDialog.dart';


class InscriptionScreen extends StatelessWidget {

  final Color themeColor = Colors.black;

  final PersonalInput nom = new PersonalInput(hinText: "Nom", color: Colors.black,control: new TextEditingController(),icon: Icon(CupertinoIcons.person_add),);

  final PersonalInput prenoms = new PersonalInput(hinText: "Prenoms", color: Colors.black,control: new TextEditingController(),icon: Icon(CupertinoIcons.person_add),);

  final PersonalInput pseudo = new PersonalInput(hinText: "Pseudo", color: Colors.black,control: new TextEditingController(),icon: Icon(CupertinoIcons.person),);

  final PersonalInput password = new PersonalInput(hinText: "Password", color: Colors.black,control: new TextEditingController(),icon: Icon(CupertinoIcons.padlock),obscur: true,isPassWordField: true,);

  final PersonalInput confirmPassword = new PersonalInput(hinText: "Confirm Password", color: Colors.black,control: new TextEditingController(),icon: Icon(CupertinoIcons.padlock),obscur: true,isPassWordField: true,);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 80,left: 50,right: 50,bottom: 80),
        child: Column(
          children: <Widget>[
            Text("INSCRIPTION",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color: themeColor), ),
            SizedBox(height: 50),
            nom,
            SizedBox(height: 50,),
            prenoms,
            SizedBox(height: 50,),
            pseudo,
            SizedBox(height: 50,),
            password,
            SizedBox(height: 50,),
            confirmPassword,
            SizedBox(height: 50,),

            PersonalButton(text :"S'inscrire",buttonColor: themeColor,textSize: 25,paddingl: 70, paddingr: 70,paddingt: 15,paddingb: 15 ,radius: 10,onClick: () {
              loadingAlertDialog(context, "Chagement en cours ...");
              this.check(
                this.pseudo.getControllerText,
                this.nom.getControllerText,
                this.prenoms.getControllerText,
                this.password.getControllerText,
                this.confirmPassword.getControllerText,
                context
            );

              },)
          ],
        ),
      ),
    );
  }



  Future<bool> docExist(String doc) async{

    final fireStoreConnector = Firestore.instance;

    DocumentSnapshot ds = await fireStoreConnector.collection("comptes").document(doc).get();

    return ds.exists;
  }


  void check(String pseudo, String nom , String prenoms ,String password, String confPassword,BuildContext context) {
    if(pseudo.isEmpty || nom.isEmpty || prenoms.isEmpty || confPassword.isEmpty) {

      Navigator.of(context).pop();
      showAlertDialog(context, "Veuillez remplir tous les champs !!!");

    } else {   

        Future<bool> result = this.docExist(pseudo);

        result.then(
            (bool value) {

              if(value == true) {

                Navigator.of(context).pop();
                showAlertDialog(context, "Le pseudo existe deja. Veuillez choisir un autre pseudo !");

              } else {

                if(password == confPassword) {

                  try {
                    this.register(
                        this.pseudo.getControllerText,
                        this.nom.getControllerText,
                        this.prenoms.getControllerText,
                        this.password.getControllerText,
                        this.confirmPassword.getControllerText,
                        context
                    );
                    Navigator.of(context).pop();
                    showAlertDialog(context, "Inscription reussie");
                    this.nom.setControllerText = "";
                    this.prenoms.setControllerText = "";
                    this.pseudo.setControllerText = "";
                    this.password.setControllerText = "";
                    this.confirmPassword.setControllerText = "";

                  } catch (e) {

                    print(e);
                    Navigator.of(context).pop();
                    showAlertDialog(context, "Verifiez votre connexion à internet");

                  }

                }else {
                  Navigator.of(context).pop();
                  showAlertDialog(context, "Les mots de passe ne correspondent pas !");
                  this.confirmPassword.setControllerText = "";

                }

              }

            },

          onError: (error) {
            print(error);
            Navigator.of(context).pop();
            showAlertDialog(context, "Verifiez votre connexion à internet");
          }
        );

    }
  }


  void register(String pseudo, String nom, String prenoms, String password, String confPass,BuildContext context) async {

    final fireStoreConnector = Firestore.instance;

    final Map<String,dynamic> data = {"pseudo":pseudo,"nom":nom,"prenoms":prenoms,"password":password,"connected": false};

    await fireStoreConnector.collection("comptes")
        .document(pseudo)
        .setData(data);

  }

}