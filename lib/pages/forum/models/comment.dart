// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  String model;
  int pk;
  Fields fields;

  Comment({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
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
  int post;
  dynamic parent;
  String text;
  DateTime dateAdded;

  Fields({
    required this.user,
    required this.post,
    required this.parent,
    required this.text,
    required this.dateAdded,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        post: json["post"],
        parent: json["parent"],
        text: json["text"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "post": post,
        "parent": parent,
        "text": text,
        "date_added": dateAdded.toIso8601String(),
      };
}
