import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lets_chat/functions/functions.dart';
import 'package:lets_chat/models/ConvElement.dart';
import 'package:lets_chat/widgets/PersonnalInput.dart';
import 'package:lets_chat/widgets/Message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_chat/widgets/AlertDialog.dart';
import 'package:lets_chat/style/style.dart';
import 'package:lets_chat/widgets/avatar.dart';
import 'package:lets_chat/widgets/ButtonIcon.dart';

class ConversationUserScreen extends StatefulWidget {
  String friend;
  String user;
  bool friendIsConnected;

  ConversationUserScreen(
      {this.user, this.friend = "UICreation", this.friendIsConnected});

  @override
  _ConversationUserScreenState createState() => _ConversationUserScreenState();
}

class _ConversationUserScreenState extends State<ConversationUserScreen> {
  SharedPreferences preferences;

  List<Widget> messages = [];

  File image;
  String imageName;
  Timestamp time;
  String defaultAvatarImg =
      "https://firebasestorage.googleapis.com/v0/b/letschat-1234.appspot.com/o/avatar.png?alt=media&token=b7575fdd-ca24-4569-b0c5-fb597e52da23";

  PersonalInput message = new PersonalInput(
    isPassWordField: false,
    radius: 30,
    control: new TextEditingController(),
    color: Colors.black,
    maxLines: 3,
    keyBoard: TextInputType.multiline,
    padLeft: 20,
    padRight: 20,
    borderWidth: 2,
     hinText: "Entrez votre message ...",
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.updateSharePref();
  }

  updateSharePref() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: background,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 26.0, bottom: 10.0),
              decoration: BoxDecoration(color: background, boxShadow: [
                BoxShadow(
                    color: darkShadow,
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                    spreadRadius: 2.0)
              ]),
              child: Row(
                children: [
                  ButtonIcon(
                    icon: Icons.arrow_back,
                    action: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 16.0),
                  FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref()
                          .child('profils/${widget.friend}')
                          .getDownloadURL(),
                      builder: (context, url) {
                        if (!url.hasData) {
                          return Avatar(
                            url: defaultAvatarImg,
                            isOnline: widget.friendIsConnected,
                          );
                        } else {
                          return Avatar(
                            url: url.data,
                            isOnline: widget.friendIsConnected,
                          );
                        }
                      }),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.friend,
                           style: TextStyle(
                              color: textColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                            widget.friendIsConnected
                                ? 'En ligne'
                                : 'Hors ligne',
                            style: TextStyle(
                              color: textColor.withOpacity(.54),
                              fontSize: 14.0,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0),
                  ButtonIcon(icon: Icons.phone),
                  SizedBox(width: 10.0),
                  ButtonIcon(icon: Icons.videocam),
                  SizedBox(width: 10.0),
                  ButtonIcon(icon: Icons.info),
                ],
              ),
            ),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('discussion')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  DocumentSnapshot docSnap;

                  messages.clear();

                  for (docSnap in snapshot.data.documents) {
                    if ((docSnap.data['expediteurUid'] == widget.user &&
                            docSnap.data['destinataireUid'] == widget.friend) ||
                        (docSnap.data['expediteurUid'] == widget.friend &&
                            docSnap.data['destinataireUid'] == widget.user)) {
                      messages.add(Message(
                          docSnap.data['expediteurUid'],
                          docSnap.data['content'],
                          widget.user,
                          docSnap.data['type'],
                          docSnap.data['url']));
                    }
                  }

                  if (messages.length == 0) {
                    return Expanded(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 13, bottom: 13, left: 20, right: 20),
                          child: Text(
                            "Vous pouvez envoyer des messages à ${widget.friend}",
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
                  }

                  return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        return messages[i];
                      },
                    ),
                  );
                }),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              decoration: BoxDecoration(color: background, boxShadow: [
                BoxShadow(
                    color: lightShadow,
                    offset: Offset(0, 0),
                    blurRadius: 6.0,
                    spreadRadius: 4.0)
              ]),
              child: Row(
                children: <Widget>[
                  ButtonIcon(
                    icon: Icons.image,
                    action: () async {
                      image = await getFuture(
                          ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 20));

                      if (image != null) {
                        loadingAlertDialog(context, "Envoi en cours ...");
                        time = Timestamp.now();
                        imageName = time.seconds.toString();

                        StorageReference storageReference = FirebaseStorage
                            .instance
                            .ref()
                            .child('chats/$imageName');
                        StorageUploadTask uploadTask =
                            storageReference.putFile(image);
                        await uploadTask.onComplete;

                        this.sendMessage(
                            this.preferences.getString('user'),
                            message.getControllerText,
                            widget.friend,
                            time,
                            "image",
                            "chats/$imageName");

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SizedBox(width: 10.0),
                  ButtonIcon(icon: Icons.camera_alt,
                     action: () async {
                        image = await getFuture(
                           ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 20));

                        if (image != null) {
                           loadingAlertDialog(context, "Envoi en cours ...");
                           time = Timestamp.now();
                           imageName = time.seconds.toString();

                           StorageReference storageReference = FirebaseStorage
                              .instance
                              .ref()
                              .child('chats/$imageName');
                           StorageUploadTask uploadTask =
                           storageReference.putFile(image);
                           await uploadTask.onComplete;

                           this.sendMessage(
                              this.preferences.getString('user'),
                              message.getControllerText,
                              widget.friend,
                              time,
                              "image",
                              "chats/$imageName");

                           Navigator.of(context).pop();
                        }
                     },
                  ),
                  SizedBox(width: 10.0),
                  ButtonIcon(icon: Icons.mic),
                   SizedBox(width: 10.0),
                  Expanded(
                    child: message,
                  ),
                   SizedBox(width: 10.0),
                  ButtonIcon(
                     icon: Icons.send,
                     action: () {
                        if (message.getControllerText.isNotEmpty &&
                           message.getControllerText.trim() != "") {
                           this.sendMessage(
                              this.preferences.getString('user'),
                              message.getControllerText,
                              widget.friend,
                              Timestamp.now(),
                              "text",
                              "");
                           setState(() {
                              //messages.add(Message(this.preferences.getString('userPseudo'), message.getControllerText));
                              message.setControllerText = "";
                           });
                        }
                     },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage(String exp, String content, String dest, Timestamp date,
      String type, String url) async {
    ConvElement message = new ConvElement(exp, content, dest, date, type, url);
    final db = Firestore.instance;
    await db.collection('discussion').add(message.toJson());
  }
}
