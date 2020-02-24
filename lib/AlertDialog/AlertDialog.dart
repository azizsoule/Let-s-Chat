import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String msg) {
  showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),

        title: Text(msg),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(left: 30,right: 30,top: 13,bottom: 13),
                child: Text(
                  "Ok",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              borderRadius: BorderRadius.circular(20),
              onTap: () {Navigator.of(context).pop();},
            )
          ],
        ),
      )
  );
}


void loadingAlertDialog(BuildContext context, String msg) {
  showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),

        title: Text(msg),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
            CircularProgressIndicator(),
          ],
        ),
      )
  );
}