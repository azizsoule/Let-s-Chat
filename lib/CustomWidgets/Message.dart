import 'package:flutter/material.dart';

class Message extends StatelessWidget {

  String message;

  bool areYouSender;

  Message({this.message, this.areYouSender = false });

  String get getMessage => this.message;

  MainAxisAlignment alignement() {
    if(this.areYouSender) {
      return MainAxisAlignment.end;
    }
    else {
      return MainAxisAlignment.start;
    }
  }

  EdgeInsets pad() {
    if(this.areYouSender) {
      return EdgeInsets.only(top: 10,bottom: 10,right: 10);
    } else {
      return EdgeInsets.only(top: 10,bottom: 10,left: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignement(),
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: pad(),
          child: Text(message,style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,

          ),),
          padding: EdgeInsets.only(top: 14,bottom: 14,left: 15,right: 15),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20)
          ),
        ),
      ],
    );
  }
}

