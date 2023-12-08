// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

List<Report> reportFromJson(String str) =>
    List<Report>.from(json.decode(str).map((x) => Report.fromJson(x)));

String reportToJson(List<Report> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Report {
  String model;
  int pk;
  Fields fields;

  Report({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
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
  int book;
  String bookTitle;
  int user;
  String comment;
  DateTime dateAdded;

  Fields({
    required this.book,
    required this.bookTitle,
    required this.user,
    required this.comment,
    required this.dateAdded,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        bookTitle: json["book_title"],
        user: json["user"],
        comment: json["comment"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "book": book,
        "book_title": bookTitle,
        "user": user,
        "comment": comment,
        "date_added": dateAdded.toIso8601String(),
      };
}
