import 'package:flutter/material.dart';
import 'views/ConnectedUserHomeScreen.dart';
import 'package:lets_chat/LetsChatApp.dart';
import 'package:lets_chat/views/ConversationUserScreen.dart';
import 'package:lets_chat/models/User.dart';

void main() {

  runApp(LetsChatApp());
}

/*Future<String> getUser () async{
  SharedPreferences preference = await SharedPreferences.getInstance();

  return preference.get('userPseudo');
}*/
