
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/style/style.dart';

// ignore: must_be_immutable
class PersonalInput extends StatefulWidget {

  TextEditingController control;
  double radius;
  String hinText;
  Icon icon;
  final Color color;
  bool obscur;
  bool isPassWordField;
  int num = 0;
  int maxLines;
  int minLines;
  double padLeft;
  double padRight;
  double borderWidth;
  TextInputType keyBoard;
  bool enabled;
  bool autoFaucus;

  PersonalInput({
    this.hinText = "",
    this.control,
    this.radius = 30.0,
    this.icon,
    this.color = Colors.black,
    this.obscur = false,
    this.isPassWordField = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyBoard = TextInputType.text,
    this.padLeft = 5,
    this.padRight = 5,
    this.borderWidth = 1.0,
    this.enabled = true,
    this.autoFaucus = false
  });


  TextEditingController get getController => this.control;

  String get getControllerText => this.control.text;


  set setControllerText(String value) {
    this.control.text = value;
  }

  @override
  _PersonalInputState createState() => _PersonalInputState();
}

class _PersonalInputState extends State<PersonalInput> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
         color: background,
         boxShadow: softShadowsInvert,
         borderRadius: BorderRadius.circular(widget.radius)),
      child: TextFormField(
        autofocus: widget.autoFaucus,
        style: TextStyle(color: textColor, fontSize: 16.0),
        enabled: widget.enabled,
        keyboardType: widget.keyBoard,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        onTap: () {
          widget.num ++;
          if(widget.isPassWordField == true && widget.num>=2) {
            setState(() {
              if(widget.obscur == true) {
                widget.obscur = false;
              } else {
                widget.obscur = true;
              }
            });
          }
        },
        controller: widget.control,
        cursorColor: widget.color,
        cursorRadius: Radius.circular(20),
        obscureText: widget.obscur,
        decoration: InputDecoration(
          icon: widget.icon,
          border: InputBorder.none,
          hintText: widget.hinText,
          hintStyle: TextStyle(color: textColor.withOpacity(.6)),
           filled: false,
           isDense: true,
           contentPadding: EdgeInsets.symmetric(
              horizontal: 6.0, vertical: 8.0),
        ),
      ),
    );
  }
}

