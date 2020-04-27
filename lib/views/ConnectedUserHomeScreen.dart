import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/functions/functions.dart';
import 'package:lets_chat/style/style.dart';
import 'package:lets_chat/widgets/UserDrawer.dart';
import 'package:lets_chat/views/ConversationUserScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_chat/widgets/avatar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ConnectedUserHomeScreen extends StatefulWidget {
  List<Widget> items = [];
  String pseudo;

  ConnectedUserHomeScreen({this.pseudo});

  @override
  _ConnectedUserHomeScreenState createState() =>
      _ConnectedUserHomeScreenState();
}

class _ConnectedUserHomeScreenState extends State<ConnectedUserHomeScreen> {

  final FirebaseMessaging _fcm = new FirebaseMessaging();

  String defaultAvatarImg =
      "https://firebasestorage.googleapis.com/v0/b/letschat-1234.appspot.com/o/avatar.png?alt=media&token=b7575fdd-ca24-4569-b0c5-fb597e52da23";

  String userAvatar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fcm.configure(
       onMessage: (message) {
         print(message);
         return null;
       },
       onResume: (message) {
         print(message);
         return null;
       },
       onLaunch: (message) {
         print(message);
         return null;
       }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: UserDrawer(widget.pseudo, context)),
      body: Container(
        color: background,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    FutureBuilder(
                        future: FirebaseStorage.instance
                            .ref()
                            .child('profils/${widget.pseudo}')
                            .getDownloadURL(),
                        builder: (context, url) {
                          if (!url.hasData) {
                            return Avatar(
                              url: defaultAvatarImg,
                              isOnline: false,
                            );
                          } else {
                            return Avatar(
                              url: url.data,
                              isOnline: false,
                            );
                          }
                        }),

                    SizedBox(width: 10.0),
                    // name
                    Text(widget.pseudo,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            boxShadow: softShadows,
                            color: background,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16.0,
                          color: Theme.of(context).primaryColor,
                        ))
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      color: background,
                      boxShadow: softShadowsInvert,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                              boxShadow: softShadows,
                              color: background,
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.search,
                            size: 16.0,
                            color: Theme.of(context).primaryColor,
                          )),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: textColor, fontSize: 16.0),
                          decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle:
                                  TextStyle(color: textColor.withOpacity(0.6)),
                              filled: false,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 12.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                stream: Firestore.instance.collection("comptes").snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return Expanded(
                       child: Center(
                          child: Container(
                             padding: EdgeInsets.only(
                                top: 13, bottom: 13, left: 20, right: 20),
                             child: Text(
                                "Aucun utilisateur !",
                                style: TextStyle(color: textColor,),
                             ),
                             decoration: BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: softShadows
                             ),
                          ),
                       ),
                    );
                  } else {
                    widget.items.clear();

                    DocumentSnapshot element;

                    //Future<String> userPseudo = getUser();

                    for (element in snapshots.data.documents) {
                      if (widget.pseudo != element.data['pseudo']) {
                        widget.items.add(buildListItem(
                          context: context,
                          data: element,
                          pseudo: widget.pseudo,
                          defaultAvatarImg: defaultAvatarImg,
                        ));
                      }
                    }

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            return widget.items[index];
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class buildListItem extends StatelessWidget {
  BuildContext context;
  DocumentSnapshot data;
  String pseudo;
  String defaultAvatarImg;

  buildListItem({this.context, this.data, this.pseudo, this.defaultAvatarImg});

  Container isConnected() {
    if (data['connected']) {
      return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      );
    } else {
      return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      );
    }
  }
// no need of the file extension, the name will do fine.

  List<dynamic> messages = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
         .collection('discussion')
         .orderBy('date')
         .snapshots(),
      builder: (context, snapshot) {
        DocumentSnapshot docSnap;

        //messages.clear();

        for (docSnap in snapshot.data.documents) {
          if ((docSnap.data['expediteurUid'] == pseudo &&
             docSnap.data['destinataireUid'] == data['pseudo']) ||
             (docSnap.data['expediteurUid'] == data['pseudo'] &&
                docSnap.data['destinataireUid'] == pseudo)) {
            messages.add({
              "message": docSnap.data['content'],
              "date": docSnap.data['date'],
              "type": docSnap.data['type']
            });
          }
        }

        String lastMes;
        var time;

        if(messages.length == 0) {
          lastMes = "Aucun message";
          time = "";
        }else {
          if(messages.last['type'] == "text") {
            lastMes = messages.last['message'];
            time = messages.last['date'].toDate().hour.toString() + ":" + messages.last['date'].toDate().minute.toString();
          }

          if(messages.last['type'] == "image") {
            lastMes = "Photo";
            time = messages.last['date'].toDate().hour.toString() + ":" + messages.last['date'].toDate().minute.toString();
          }
        }

        return ListTile(
          contentPadding: EdgeInsets.only(top: 15, bottom: 15, left: 12, right: 12),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ConversationUserScreen(
                friend: data['pseudo'],
                user: pseudo,
                friendIsConnected: data['connected'],
              );
            }));
          },
          leading: FutureBuilder(
              future: FirebaseStorage.instance
                  .ref()
                  .child('profils/${data['pseudo']}')
                  .getDownloadURL(),
              builder: (context, url) {
                if (!url.hasData) {
                  return Avatar(
                    url: defaultAvatarImg,
                    isOnline: data['connected'],
                  );
                } else {
                  return Avatar(
                    url: url.data,
                    isOnline: data['connected'],
                  );
                }
              }),
          title: Text(data['pseudo'],
              style: TextStyle(
                  color: textColor, fontSize: 17.0, fontWeight: FontWeight.bold)),
          subtitle: Text(lastMes),
          trailing: Text(
              time,
              style: TextStyle(color: textColor.withOpacity(.6), fontSize: 14.0)),
        );
      }
    );
  }
}
