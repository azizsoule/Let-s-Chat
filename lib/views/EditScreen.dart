import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lets_chat/style/style.dart';
import 'package:lets_chat/widgets/PersonnalInput.dart';
import 'package:lets_chat/widgets/PersonalButon.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:lets_chat/widgets/AlertDialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_chat/functions/functions.dart';
import 'package:lets_chat/widgets/ButtonIcon.dart';

class EditScreen extends StatefulWidget {
  final BuildContext context;
  String pseudo;

  EditScreen({this.context, this.pseudo});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {


  File image;

  final PersonalInput nom = new PersonalInput(
    hinText: "Nom",
    color: textColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.person_add),
  );

  final PersonalInput prenoms = new PersonalInput(
    hinText: "Prenoms",
    color: textColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.person_add),
  );

  final PersonalInput pseudo = new PersonalInput(
    hinText: "Pseudo",
    color: textColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.person),
    enabled: false,
  );

  final PersonalInput password = new PersonalInput(
    hinText: "Password",
    color: textColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.padlock),
    obscur: true,
    isPassWordField: true,
  );

  final PersonalInput newPassword = new PersonalInput(
    hinText: "New password",
    color: textColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.padlock),
    obscur: true,
    isPassWordField: true,
  );

  final PersonalInput confirmNewPassword = new PersonalInput(
    hinText: "Confirm new Password",
    color: textColor,
    control: new TextEditingController(),
    icon: Icon(CupertinoIcons.padlock),
    obscur: true,
    isPassWordField: true,
  );

  String defaultAvatarImg =
      "https://firebasestorage.googleapis.com/v0/b/letschat-1234.appspot.com/o/avatar.png?alt=media&token=b7575fdd-ca24-4569-b0c5-fb597e52da23";

  @override
  Widget build(BuildContext context) {

     dynamic imageChild = FutureBuilder(
        future: FirebaseStorage.instance
           .ref()
           .child('profils/${widget.pseudo}')
           .getDownloadURL(),
        builder: (context, url) {
           if (!url.hasData) {
              return Image.network(
                 defaultAvatarImg,
                 height: 200,
                 width: 200,
              );
           } else {
              return Image.network(
                 url.data,
                 height: 200,
                 width: 200,
              );
           }
        });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[

             Container(
                decoration: BoxDecoration(
                   boxShadow:softShadows
                ),
               child: Row(
                  children: <Widget>[
                     Padding(
                        padding: const EdgeInsets.only(left: 12,top: 20,bottom: 20,right: 20),
                        child: ButtonIcon(
                           icon: Icons.arrow_back,
                           action: () => Navigator.of(context).pop(),
                        ),
                     ),
                     Text(
                        "Parametres",
                        style: TextStyle(
                           color: textColor,
                           fontSize: 20,
                           fontWeight: FontWeight.bold),
                     ),
                  ],
               ),
             ),

            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("comptes")
                    .document(widget.pseudo)
                    .snapshots(),
                builder: (context, snapshot) {
                  pseudo.setControllerText = snapshot.data['pseudo'];
                  nom.setControllerText = snapshot.data['nom'];
                  prenoms.setControllerText = snapshot.data['prenoms'];
                  password.setControllerText = snapshot.data['password'];
                  return Flex(direction: Axis.vertical, children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        margin: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(30),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              MaterialButton(
                                onPressed: () async {
                                  image = await getFuture(ImagePicker.pickImage(
                                      source: ImageSource.gallery, imageQuality: 20));

                                  if (image == null) {
                                    imageChild = Image.network(
                                      defaultAvatarImg,
                                      height: 200,
                                      width: 200,
                                    );
                                  } else {
                                    imageChild = Image.file(
                                      image,
                                      height: 200,
                                      width: 200,
                                    );
                                  }

                                  setState(() {});
                                },
                                child: Center(
                                  child: ClipRRect(
                                    child: Container(
                                      child: imageChild,
                                      decoration: BoxDecoration(color: Colors.black),
                                    ),
                                    borderRadius: BorderRadius.circular(1000),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              pseudo,
                              SizedBox(
                                height: 25,
                              ),
                              nom,
                              SizedBox(
                                height: 25,
                              ),
                              prenoms,
                              SizedBox(
                                height: 25,
                              ),
                              password,
                              SizedBox(
                                height: 25,
                              ),
                              newPassword,
                              SizedBox(
                                height: 25,
                              ),
                              confirmNewPassword,
                              SizedBox(
                                height: 25,
                              ),
                              PersonalButton(
                                text: "Enregistrer",
                                textSize: 25,
                                paddingl: 70,
                                paddingr: 70,
                                paddingt: 15,
                                paddingb: 15,
                                radius: 10,
                                color: textColor,
                                onClick: () async {
                                  StorageReference storageReference = FirebaseStorage
                                      .instance
                                      .ref()
                                      .child('profils/${widget.pseudo}');
                                  StorageUploadTask uploadTask =
                                      storageReference.putFile(image);
                                  await uploadTask.onComplete;
                                  print('File Uploaded');
                                  storageReference.getDownloadURL().then((fileURL) {
                                    print(fileURL);
                                  });

                                  try {
                                    final result =
                                        await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {}
                                  } on SocketException catch (_) {
                                    showAlertDialog(context,
                                        "Veuillez véeifier votre connexion à internet !!!");
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*void check(String pseudo, String nom , String prenoms ,String password, String confPassword,BuildContext context) async {
     if(pseudo.isEmpty || nom.isEmpty || prenoms.isEmpty || confPassword.isEmpty) {

        showAlertDialog(context, "Veuillez remplir tous les champs !!!");

     } else {
        loadingAlertDialog(context, "Chagement en cours ...");

        var result = await getFuture(docExist(pseudo));

        if(result == true) {

           Navigator.of(context).pop();
           showAlertDialog(context, "Le pseudo existe deja. Veuillez choisir un autre pseudo !");

        } else {

           if(password == confPassword) {

              register(
                 this.pseudo.getControllerText,
                 this.nom.getControllerText,
                 this.prenoms.getControllerText,
                 this.password.getControllerText,
                 this.confirmNewPassword.getControllerText,
                 context
              );
              Navigator.of(context).pop();
              showAlertDialog(context, "Inscription reussie");
              this.nom.setControllerText = "";
              this.prenoms.setControllerText = "";
              this.pseudo.setControllerText = "";
              this.password.setControllerText = "";
              this.confirmNewPassword.setControllerText = "";

           }else {
              Navigator.of(context).pop();
              showAlertDialog(context, "Les mots de passe ne correspondent pas !");
              this.confirmNewPassword.setControllerText = "";
           }

        }

     }
  }*/
}
