import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message extends StatelessWidget {

  String message;
  String expe;
  String userPseudo;

  SharedPreferences preferences;

  Message(this.expe, this.message,this.userPseudo);

  //String get getMessage => this.message;

  updateSharePref() async{

    this.preferences = await SharedPreferences.getInstance();
  }

  MainAxisAlignment alignement() {
    if(this.userPseudo == this.expe) {
      return MainAxisAlignment.end;
    }
    else {
      return MainAxisAlignment.start;
    }
  }

  EdgeInsets pad() {
    if(this.userPseudo == this.expe) {
      return EdgeInsets.only(top: 10,bottom: 10,right: 10,left: 50);
    }
    else {
      return EdgeInsets.only(top: 10,bottom: 10,right: 50,left: 10);
    }
  }

  BoxDecoration deco () {
    if(this.userPseudo == this.expe) {
      return BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20)
      );
    } else {
      return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black
        )
      );
    }
  }


  TextStyle style() {
    if(this.userPseudo == this.expe) {
      return TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,

      );
    }else {
      return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 17,

      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignement(),
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(child: Container(
          margin: pad(),
          child: Text(message,style: style()),
          padding: EdgeInsets.only(top: 14,bottom: 14,left: 15,right: 15),
          decoration: deco(),
        ),)
      ],
    );
  }
}

