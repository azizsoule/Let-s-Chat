import 'package:lets_chat/LetsChatApp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/views/EditScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_chat/style/style.dart';
import 'package:lets_chat/widgets/ButtonIcon.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();

  String userPseudo;
  BuildContext context;

  UserDrawer( this.userPseudo, this.context);
}

class _UserDrawerState extends State<UserDrawer> {

  String defaultAvatarImg =
     "https://firebasestorage.googleapis.com/v0/b/letschat-1234.appspot.com/o/avatar.png?alt=media&token=b7575fdd-ca24-4569-b0c5-fb597e52da23";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
           future: FirebaseStorage.instance.ref().child('profils/${widget.userPseudo}').getDownloadURL(),
           builder: (context,url) {
             if(!url.hasData) {
               return Image.network(defaultAvatarImg,height: 200,fit: BoxFit.scaleDown);
             }else {
               return Image.network(url.data, height: 200,fit: BoxFit.cover,);
             }
           }
        ),
        Expanded(
          child: StreamBuilder(
              stream: Firestore.instance.collection("comptes").document(widget.userPseudo).snapshots(),
              builder: (context, snapshot) {

                if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Drawer(
                    elevation: 20,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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

        Container(
          padding: EdgeInsets.all(15),
          color: background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              ButtonIcon(
                icon: Icons.clear,
                action: () {
                  deConnexion(context,widget.userPseudo);
                },
              ),

              ButtonIcon(
                icon: Icons.create,
                action: () {
                  Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) {
                       return EditScreen(context: context,pseudo: widget.userPseudo,);
                     })
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget DrawerItems(String title,String key,DocumentSnapshot data)  {

    var password = "";

    for(int i= 0; i<data['password'].length;i++) {
      password = password + "*";
    }

    if(key=='password') {
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
            color: background,
            borderRadius: BorderRadius.circular(20),
            boxShadow: softShadows,
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
             color: background,
             borderRadius: BorderRadius.circular(20),
             boxShadow: softShadows,
          ),
          margin: EdgeInsets.only(top: 20,left: 20,right: 20),
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text(data[key], style: TextStyle(fontSize: 15,color: Colors.grey),)
            ],
          ),
        ),
      );
    }

  }

  deConnexion (BuildContext context, String pseudo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('user');
    Firestore.instance.collection("comptes").document(pseudo).updateData(
       {"connected": false});
    Navigator.of(context).pushAndRemoveUntil(
       MaterialPageRoute(
         builder: (context) {
           return LetsChatApp();
         }
       ), (Route<dynamic> route) => false);
  }
}