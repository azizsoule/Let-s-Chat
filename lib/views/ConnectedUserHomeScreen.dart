import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/widgets/AlertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/widgets/UserDrawer.dart';
import 'package:lets_chat/views/ConversationUserScreen.dart';

class ConnectedUserHomeScreen extends StatefulWidget {
  List<Widget> items = [];
  String pseudo;

  ConnectedUserHomeScreen({this.pseudo});

  @override
  _ConnectedUserHomeScreenState createState() =>
      _ConnectedUserHomeScreenState();
}

class _ConnectedUserHomeScreenState extends State<ConnectedUserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: UserDrawer(widget.pseudo, context)),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Let's Chat"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("comptes").snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(child: Text("Aucun utilisateur"));
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
                ));
              }
            }

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return widget.items[index];
              },
            );
          }
        },
      ),
    );
  }
}

class buildListItem extends StatelessWidget {
  BuildContext context;
  DocumentSnapshot data;
  String pseudo;

  buildListItem({this.context, this.data, this.pseudo});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(13),
      child: ListTile(
        contentPadding:
            EdgeInsets.only(top: 15, bottom: 15, left: 12, right: 12),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ConversationUserScreen(
              friend: data['pseudo'],
              user: pseudo,
            );
          }));
        },
         leading: CircleAvatar(
            backgroundColor: Colors.black,
         ),
        title: Text(data['pseudo']),
        trailing: isConnected(),
      ),
      decoration: BoxDecoration(
         color: Colors.white,
          boxShadow: <BoxShadow> [
             BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
             )
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
