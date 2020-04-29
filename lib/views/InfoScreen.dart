import 'package:flutter/material.dart';
import 'package:lets_chat/widgets/ButtonIcon.dart';
import 'package:lets_chat/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_chat/functions/functions.dart';
import 'package:photo_view/photo_view.dart';


class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();

  String friend;

  InfoScreen(this.friend);
}

class _InfoScreenState extends State<InfoScreen> {

   String defaultAvatarImg =
      "https://firebasestorage.googleapis.com/v0/b/letschat-1234.appspot.com/o/avatar.png?alt=media&token=b7575fdd-ca24-4569-b0c5-fb597e52da23";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: background,
        body: SafeArea(
            child: Column(
               children: <Widget>[
                  Container(
                    color: background,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, top: 20, bottom: 20, right: 20),
                          child: ButtonIcon(
                            icon: Icons.arrow_back,
                            action: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Text(
                          "Infos ${widget.friend}",
                          style: TextStyle(
                              color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                     ),
                  ),

                  //SizedBox(height: 50,),

                  Expanded(
                     child: StreamBuilder(
                        stream: Firestore.instance.collection("comptes").document(widget.friend).snapshots(),
                        builder: (context, snapshot) {

                           if(!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                           } else {
                              return Container(
                                child: SingleChildScrollView(
                                   physics: BouncingScrollPhysics(),
                                   padding: EdgeInsets.all(20),
                                   child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                   InkWell(
                                      borderRadius: BorderRadius.circular(1000),
                                      onTap: () async{
                                         dynamic img = await getFuture(
                                            FirebaseStorage.instance.ref().child("profils/${widget.friend}").getDownloadURL());

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
                                                                    "Photo de ${widget.friend}",
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
                                     child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1000),
                                       child: Container(
                                          color: Colors.black,
                                         child: FutureBuilder(
                                         future: FirebaseStorage.instance
                                            .ref()
                                            .child('profils/${widget.friend}')
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
                                         }),
                                       ),
                                     ),
                                   ),

                                         infoItem("Pseudo", 'pseudo', snapshot.data),

                                         infoItem("Nom", 'nom', snapshot.data),

                                         infoItem("Prenoms", 'prenoms', snapshot.data),

                                      ],
                                   ),
                                ),
                              );
                           }
                        }
                     ),
                  ),
               ]
            )
        )
    );
  }

  Widget infoItem(String title,String key,DocumentSnapshot data)  {

     return Row(
       children: <Widget>[
         Expanded(
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
                     Text(title, style: TextStyle(fontSize: 20, color: textColor,fontWeight: FontWeight.bold),),
                     Text(data[key], style: TextStyle(fontSize: 15,color: Colors.grey),)
                  ],
               ),
            ),
         ),
       ],
     );

  }
}
