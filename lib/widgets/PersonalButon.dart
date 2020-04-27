import 'package:flutter/material.dart';
import 'package:lets_chat/style/style.dart';

class PersonalButton extends StatelessWidget {

  final String text;
  final Color buttonColor;
  final Function onClick;
  final double paddingt;
  final double paddingl;
  final double paddingr;
  final double paddingb;
  final double radius;
  final double textSize;
  final Color color;

  const PersonalButton({
    this.text = "",
    this.buttonColor = Colors.amber,
    this.onClick,
    this.paddingt = 8,
    this.paddingl = 8,
    this.paddingr = 8,
    this.paddingb = 8,
    this.radius = 0,
    this.textSize = 20,
    this.color = Colors.black,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(this.radius),
      onTap: this.onClick,
      child: Container(
        padding: EdgeInsets.only(top: this.paddingt,right: this.paddingr,left: this.paddingl,bottom: this.paddingb),
        child: Text(this.text,style: TextStyle(fontWeight: FontWeight.bold,color:color,fontSize: this.textSize),),
        decoration: BoxDecoration(
           boxShadow: softShadows,
           color: background,
           borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}
