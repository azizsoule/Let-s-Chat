import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/CustomWidgets/PersonnalInput.dart';
import 'package:lets_chat/CustomWidgets/Message.dart';


class ConversationUserScreen extends StatefulWidget {

  String friend;

  ConversationUserScreen(
    {
      this.friend = "UICreation"
    }
  ) ;

  @override
  _ConversationUserScreenState createState() => _ConversationUserScreenState();
}

class _ConversationUserScreenState extends State<ConversationUserScreen> {

  List<Widget> messages = [
  ];

  PersonalInput message = new PersonalInput(isPassWordField: false,radius: 5,control: new TextEditingController(),color: Colors.black,maxLines: 3,keyBoard: TextInputType.multiline,);

  ScrollController control = new ScrollController(initialScrollOffset: 20);

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
          children: <Widget>[

            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, i) {
                  return messages[i];
                },
                controller: control,
              ),
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
                          setState(() {
                            messages.add(Message(message: message.getControllerText,areYouSender: true));
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
}

