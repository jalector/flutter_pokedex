import 'dart:convert';

List<New> newFromJson(String str) =>
    List<New>.from(json.decode(str).map((x) => New.fromJson(x)));

String newToJson(List<New> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class New {
  int id;
  String title;
  String shortDescription;
  String url;
  String image;
  bool mobileImage;
  String alt;
  String date;
  String tags;
  bool newExternal;
  String externalTitle;
  bool externalClass;

  New({
    this.id,
    this.title,
    this.shortDescription,
    this.url,
    this.image,
    this.mobileImage,
    this.alt,
    this.date,
    this.tags,
    this.newExternal,
    this.externalTitle,
    this.externalClass,
  });

  static List<New> fronJsonCollection(List<dynamic> json) {
    List<New> list = [];
    for (var item in json) {
      list.add(New.fromJson(item));
    }
    return list.reversed.toList();
  }

  factory New.fromJson(Map<String, dynamic> json) => New(
        id: json["id"],
        title: json["title"],
        shortDescription: json["shortDescription"],
        url: json["url"],
        image: json["image"],
        mobileImage: json["mobileImage"],
        alt: json["alt"],
        date: json["date"],
        tags: json["tags"],
        newExternal: json["external"],
        externalTitle: json["externalTitle"],
        externalClass: json["externalClass"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "shortDescription": shortDescription,
        "url": url,
        "image": image,
        "mobileImage": mobileImage,
        "alt": alt,
        "date": date,
        "tags": tags,
        "external": newExternal,
        "externalTitle": externalTitle,
        "externalClass": externalClass,
      };
}
