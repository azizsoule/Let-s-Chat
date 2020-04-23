import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_chat/style/style.dart';
import 'package:lets_chat/widgets/avatar.dart';

class Message extends StatelessWidget {
  String message;
  String expe;
  String userPseudo;
  String type;
  String url;

  Message(this.expe, this.message, this.userPseudo, this.type, this.url);

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

    switch (type) {
      case "text":
        if (this.userPseudo == this.expe) {
          return Row(
            mainAxisAlignment: alignement(),
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: 50,
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  padding:
                      EdgeInsets.only(top: 14, bottom: 14, left: 15, right: 15),
                  margin: pad(),
                  child: Text(message, style: style()),
                  decoration: deco(),
                ),
              )
            ],
          );
        } else {
          return Row(
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
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: 50,
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  margin: pad(),
                  child: Text(message, style: style()),
                  padding:
                      EdgeInsets.only(top: 14, bottom: 14, left: 15, right: 15),
                  decoration: deco(),
                ),
              )
            ],
          );
        }
        break;

      case "image":
        if (this.userPseudo == this.expe) {
          return Row(
            mainAxisAlignment: alignement(),
            mainAxisSize: MainAxisSize.min,
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
                  ),
                ),
              ),
            ],
          );
        } else {
          return Row(
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
            ],
          );
        }

        break;
    }
  }
}
