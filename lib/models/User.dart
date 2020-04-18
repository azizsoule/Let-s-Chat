import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/views/ConnectedUserHomeScreen.dart';

Future<Database> open () async{
  return openDatabase(
      join(await getDatabasesPath(), 'user.db'),
      onCreate: (db,version) {
        return db.execute("CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY, pseudo VARCHAR)");
      },
      version: 1
  );
}

class User {

  final Future<Database> database = open();

  final int id;

  final String pseudo;

  User({this.id = 1,this.pseudo = ""});


  Map<String, dynamic> toMap() {
    return {
      "id":this.id,
      "pseudo":this.pseudo
    };
  }


  Future saveCurrentUser() async{
    final Database db = await database;

    db.insert('user', this.toMap());
  }


  dynamic getConnectedUser() async {
    final Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('user');

    var list =  List.generate(maps.length, (i) {
      return User(
          pseudo: maps[i]['pseudo']
      );
    });

    if(list.length == 0) {
      return 0;
    } else {
      return list[0];
    }
  }

  dynamic connectUser() {
    return ConnectedUserHomeScreen(pseudo: this.pseudo,);
  }


  Future disconnectUser() async{
    final Database db = await database;

    await db.delete(
      'user',
      where: "id = ?",
      whereArgs: [this.id]
    );
  }

}
