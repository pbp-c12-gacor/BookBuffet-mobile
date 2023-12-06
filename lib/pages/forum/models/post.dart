// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  String model;
  int pk;
  Fields fields;

  Post({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  String title;
  String text;
  DateTime dateAdded;
  DateTime dateEdited;
  dynamic book;

  Fields({
    required this.user,
    required this.title,
    required this.text,
    required this.dateAdded,
    required this.dateEdited,
    required this.book,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        text: json["text"],
        dateAdded: DateTime.parse(json["date_added"]),
        dateEdited: DateTime.parse(json["date_edited"]),
        book: json["book"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "text": text,
        "date_added": dateAdded.toIso8601String(),
        "date_edited": dateEdited.toIso8601String(),
        "book": book,
      };
}
