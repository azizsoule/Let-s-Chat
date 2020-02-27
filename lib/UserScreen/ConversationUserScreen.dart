import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lets_chat/Classes/ConvElement.dart';
import 'package:lets_chat/CustomWidgets/PersonnalInput.dart';
import 'package:lets_chat/CustomWidgets/Message.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ConversationUserScreen extends StatefulWidget {

  String friend;
  String user;

  ConversationUserScreen(
      {
        this.user,
        this.friend = "UICreation"
      }
      ) ;

  @override
  _ConversationUserScreenState createState() => _ConversationUserScreenState();
}

class _ConversationUserScreenState extends State<ConversationUserScreen> {

  SharedPreferences preferences;

  List<Widget> messages = [
  ];

  PersonalInput message = new PersonalInput(isPassWordField: false,radius: 5,control: new TextEditingController(),color: Colors.black,maxLines: 3,keyBoard: TextInputType.multiline,);

  ScrollController control = new ScrollController(initialScrollOffset: 20);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.updateSharePref();
  }

  updateSharePref() async{

    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Let's Chat",
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.friend),
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: Icon(CupertinoIcons.left_chevron,),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),

        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance.collection('discussion').orderBy('date',descending: true).snapshots(),
                builder: (context, snapshot) {

                  DocumentSnapshot docSnap ;

                  messages.clear();

                  for (docSnap in snapshot.data.documents) {
                    if((docSnap.data['expediteurUid']==widget.user && docSnap.data['destinataireUid']==widget.friend) || (docSnap.data['expediteurUid']==widget.friend && docSnap.data['destinataireUid']==widget.user)) {
                      messages.add(Message(docSnap.data['expediteurUid'],docSnap.data['content'],widget.user));
                    }
                  }

                  if(messages.length == 0) {
                    return Expanded(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 13, bottom: 13, left: 20, right: 20),
                          child: Text("Vous pouvez envoyer des messages à ${widget.friend}", style: TextStyle(color: Colors.white),),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        return messages[i];
                      },
                      controller: control,
                    ),
                  );
                }
            ),
            Container(
              margin: EdgeInsets.only(left: 20,bottom: 20,top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: message,
                  ),
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.right_chevron,
                        size: 30,
                      ),
                      onPressed: (){
                        if(message.getControllerText.isNotEmpty && message.getControllerText.trim() != "") {
                          this.sendMessage(this.preferences.getString('userPseudo'), message.getControllerText, widget.friend, Timestamp.now().seconds.toString());
                          setState(() {
                            //messages.add(Message(this.preferences.getString('userPseudo'), message.getControllerText));
                            message.setControllerText = "";
                          });
                        }
                      }
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage(String exp,String content,String dest,String date) async {

    ConvElement message = new ConvElement(exp, content, dest, date);
    final db = Firestore.instance;
    await db.collection('discussion').add(message.toJson());

  }
}
