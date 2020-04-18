
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  TextInputType keyBoard;

  PersonalInput({
    this.hinText = "",
    this.control,
    this.radius = 10,
    this.icon,
    this.color = Colors.black,
    this.obscur = false,
    this.isPassWordField = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyBoard = TextInputType.text
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
      padding: EdgeInsets.only(left: 5,right: 5),
      decoration: BoxDecoration(
          border: Border.all(color: widget.color),
        borderRadius: BorderRadius.circular(widget.radius)
      ),
      child: TextFormField(
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
        ),
      ),
    );
  }
}

