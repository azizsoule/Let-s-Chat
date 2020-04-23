import 'package:lets_chat/style/style.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/widgets/onlineIndicator.dart';

class Avatar extends StatelessWidget {
   final double width;
   final double height;
   final String url;
   final bool isOnline;

   const Avatar(
      {Key key,
         this.width = 60.0,
         this.height = 60.0,
         this.url = "https://firebasestorage.googleapis.com/v0/b/letschat-1234.appspot.com/o/avatar.png?alt=media&token=b7575fdd-ca24-4569-b0c5-fb597e52da23",
         this.isOnline = false})
      : super(key: key);

   @override
   Widget build(BuildContext context) {
      return Container(
         width: width,
         height: height,
         decoration: BoxDecoration(
            color: background,
            boxShadow: softShadows,
            shape: BoxShape.circle,
         ),
         child: Stack(
            children: <Widget>[
               Container(
                  margin: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     image: DecorationImage(
                        fit: BoxFit.cover, image: new NetworkImage(url))),
               ),
               isOnline
                  ? Positioned(
                  child: OnlineIndicator(
                     width: 0.26 * width,
                     height: 0.26 * height,
                  ),
                  right: 2,
                  bottom: 2,
               )
                  : SizedBox()
            ],
         ),
      );
   }
}