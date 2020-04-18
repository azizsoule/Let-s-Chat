class ConvElement{

  String expediteurUid;
  String content;
  String destinataireUid;
  String date;
  //bool isSender;

  ConvElement(this.expediteurUid, this.content, this.destinataireUid, this.date);

  factory ConvElement.fromJson(Map<String, dynamic> json) {
    return ConvElement(json["expediteurUid"],json["content"],json["destinataireUid"],json["date"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "expediteurUid": this.expediteurUid,
      "content": this.content,
      "destinataireUid": this.destinataireUid,
      //"isSender": this.isSender,
      "date": this.date,
    };
  }


}