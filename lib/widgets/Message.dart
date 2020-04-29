import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/functions/functions.dart';
import 'package:lets_chat/style/style.dart';
import 'package:lets_chat/widgets/ButtonIcon.dart';
import 'package:lets_chat/widgets/avatar.dart';
import 'package:photo_view/photo_view.dart';

class LcMessage extends StatelessWidget {
  String message;
  String expe;
  String userPseudo;
  String type;
  String url;
  Timestamp date;

  LcMessage(this.expe, this.message, this.userPseudo, this.type, this.url,this.date);

  String get getMessage => this.message;

  MainAxisAlignment alignement() {
    if (this.userPseudo == this.expe) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }

  EdgeInsets pad() {
    if (this.userPseudo == this.expe) {
      return EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 50);
    } else {
      return EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 10);
    }
  }

  BoxDecoration deco() {
    return BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: softShadows);
  }

  TextStyle style() {
    return TextStyle(color: textColor);
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = (this.userPseudo == this.expe);

    String defaultAvatarImg =
        "https://firebasestorage.googleapis.com/v0/b/letschat-1234.appspot.com/o/avatar.png?alt=media&token=b7575fdd-ca24-4569-b0c5-fb597e52da23";

    var tapPosition;

    void _storePosition(TapDownDetails details) {
      tapPosition = details.globalPosition;
    }

    switch (type) {
      case "text":
        if (this.userPseudo == this.expe) {
          return GestureDetector(
            onTapDown: _storePosition,
            onLongPress: () {

              final RenderBox overlay = Overlay.of(context).context.findRenderObject();

              showMenu(
                context: context,
                position: RelativeRect.fromRect(
                   tapPosition & Size(40, 40), // smaller rect, the touch area
                   Offset.zero & overlay.size   // Bigger rect, the entire screen
                ),
                items: <PopupMenuEntry> [
                  PopupMenuItem(
                    value: "copy",
                    textStyle: TextStyle(color: textColor),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.content_copy, color: Theme.of(context).primaryColor,),
                        SizedBox(width: 15,),
                        Text('Copier')
                      ],
                    ),
                  )
                ],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ).then((onValue) async {
                if(onValue == "copy") {
                  await Clipboard.setData(ClipboardData(text: this.getMessage));
                }
              });

            },
            child: Row(
              mainAxisAlignment: alignement(),
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                           minWidth: 50,
                           maxWidth: MediaQuery.of(context).size.width * 0.6),
                        padding: EdgeInsets.only(
                           top: 14, bottom: 14, left: 15, right: 15),
                        margin: pad(),
                        child: Text(message, style: style()),
                        decoration: deco(),
                      ),
                    ),

                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                           minWidth: 50,
                           maxWidth: MediaQuery.of(context).size.width * 0.6),
                        padding: EdgeInsets.only(
                            bottom: 14, left: 15, right: 15),
                        child: Text("${getDay(date)} ${date.toDate().day}/${date.toDate().month}/${date.toDate().year} à ${date.toDate().hour}:${date.toDate().minute}", style: TextStyle(color: Colors.grey),),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        } else {
          return GestureDetector(
            onTapDown: _storePosition,
            onLongPress: () {

              final RenderBox overlay = Overlay.of(context).context.findRenderObject();

              showMenu(
                context: context,
                position: RelativeRect.fromRect(
                   tapPosition & Size(40, 40), // smaller rect, the touch area
                   Offset.zero & overlay.size   // Bigger rect, the entire screen
                ),
                items: <PopupMenuEntry> [
                  PopupMenuItem(
                    value: "copy",
                    textStyle: TextStyle(color: textColor),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.content_copy, color: Theme.of(context).primaryColor,),
                        SizedBox(width: 15,),
                        Text('Copier')
                      ],
                    ),
                  )
                ],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ).then((onValue) async {
                if(onValue == "copy") {
                  await Clipboard.setData(ClipboardData(text: this.getMessage));
                }
              });

            },
            child: Row(
              mainAxisAlignment: alignement(),
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref()
                          .child('profils/${this.expe}')
                          .getDownloadURL(),
                      builder: (context, url) {
                        if (!url.hasData) {
                          return Avatar(
                            url: defaultAvatarImg,
                            isOnline: false,
                            height: 40,
                            width: 40,
                          );
                        } else {
                          return Avatar(
                            url: url.data,
                            isOnline: false,
                            height: 40,
                            width: 40,
                          );
                        }
                      }),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                           minWidth: 50,
                           maxWidth: MediaQuery.of(context).size.width * 0.6),
                        margin: pad(),
                        child: Text(message, style: style()),
                        padding: EdgeInsets.only(
                           top: 14, bottom: 14, left: 15, right: 15),
                        decoration: deco(),
                      ),
                    ),

                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                           minWidth: 50,
                           maxWidth: MediaQuery.of(context).size.width * 0.6),
                        padding: EdgeInsets.only(
                           bottom: 14, left: 15, right: 15),
                        child: Text("${getDay(date)} ${date.toDate().day}/${date.toDate().month}/${date.toDate().year} à ${date.toDate().hour}:${date.toDate().minute}", style: TextStyle(color: Colors.grey),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        break;

      case "image":
        if (this.userPseudo == this.expe) {
          return InkWell(
            onTap: () async {
              dynamic img = await getFuture(
                  FirebaseStorage.instance.ref().child(url).getDownloadURL());

              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: background,
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
                                "Votre image",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: PhotoView(imageProvider: NetworkImage(img))),
                      ],
                    ),
                  ),
                );
              }));
            },
            child: Row(
              mainAxisAlignment: alignement(),
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        margin: pad(),
                        decoration: deco(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            constraints: BoxConstraints(
                                minWidth: 50,
                                maxWidth: MediaQuery.of(context).size.width * 0.6),
                            padding: EdgeInsets.only(
                                top: 14, bottom: 14, left: 15, right: 15),
                            child: FutureBuilder(
                                future: FirebaseStorage.instance
                                    .ref()
                                    .child(this.url)
                                    .getDownloadURL(),
                                builder: (context, link) {
                                  if (!link.hasData) {
                                    return CircularProgressIndicator(
                                      backgroundColor: Colors.black,
                                    );
                                  } else {
                                    return Image.network(link.data);
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                           minWidth: 50,
                           maxWidth: MediaQuery.of(context).size.width * 0.6),
                        padding: EdgeInsets.only(
                           bottom: 14, left: 15, right: 15),
                        child: Text("${getDay(date)} ${date.toDate().day}/${date.toDate().month}/${date.toDate().year} à ${date.toDate().hour}:${date.toDate().minute}", style: TextStyle(color: Colors.grey),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return InkWell(
            onTap: () async {
              dynamic img = await getFuture(
                  FirebaseStorage.instance.ref().child(url).getDownloadURL());

              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: background,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: ButtonIcon(
                                  icon: Icons.arrow_back,
                                  action: () => Navigator.of(context).pop(),
                                ),
                              ),
                              Text(
                                "Image de ${this.expe}",
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: PhotoView(imageProvider: NetworkImage(img))),
                      ],
                    ),
                  ),
                );
              }));
            },
            child: Row(
              mainAxisAlignment: alignement(),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: FutureBuilder(
                      future: FirebaseStorage.instance
                          .ref()
                          .child('profils/${this.expe}')
                          .getDownloadURL(),
                      builder: (context, url) {
                        if (!url.hasData) {
                          return Avatar(
                            url: defaultAvatarImg,
                            isOnline: false,
                            height: 40,
                            width: 40,
                          );
                        } else {
                          return Avatar(
                            url: url.data,
                            isOnline: false,
                            height: 40,
                            width: 40,
                          );
                        }
                      }),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: pad(),
                      decoration: deco(),
                      constraints: BoxConstraints(
                          minWidth: 50,
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      padding:
                          EdgeInsets.only(top: 14, bottom: 14, left: 15, right: 15),
                      child: FutureBuilder(
                          future: FirebaseStorage.instance
                              .ref()
                              .child(url)
                              .getDownloadURL(),
                          builder: (context, link) {
                            if (!link.hasData) {
                              return CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              );
                            } else {
                              return Image.network(link.data);
                            }
                          }),
                    ),

                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                           minWidth: 50,
                           maxWidth: MediaQuery.of(context).size.width * 0.6),
                        padding: EdgeInsets.only(
                           bottom: 14, left: 15, right: 15),
                        child: Text("${getDay(date)} ${date.toDate().day}/${date.toDate().month}/${date.toDate().year} à ${date.toDate().hour}:${date.toDate().minute}", style: TextStyle(color: Colors.grey),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        break;
    }
  }
}
