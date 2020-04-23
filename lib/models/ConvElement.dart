import 'package:cloud_firestore/cloud_firestore.dart';

class ConvElement{

  String expediteurUid;
  String content;
  String destinataireUid;
  Timestamp date;
  String type;
  String url;
  //bool isSender;

  ConvElement(this.expediteurUid, this.content, this.destinataireUid, this.date,this.type,this.url);

  factory ConvElement.fromJson(Map<String, dynamic> json) {
    return ConvElement(json["expediteurUid"],json["content"],json["destinataireUid"],json["date"],json["type"],json["url"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "expediteurUid": this.expediteurUid,
      "content": this.content,
      "destinataireUid": this.destinataireUid,
      //"isSender": this.isSender,
      "date": this.date,
      "type": this.type,
      "url" : this.url
    };
  }


}