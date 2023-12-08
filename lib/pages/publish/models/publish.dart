// To parse this JSON data, do
//
//     final publish = publishFromJson(jsonString);

import 'dart:convert';

List<Publish> publishFromJson(String str) =>
    List<Publish>.from(json.decode(str).map((x) => Publish.fromJson(x)));

String publishToJson(List<Publish> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Publish {
  String model;
  int pk;
  Fields fields;

  Publish({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Publish.fromJson(Map<String, dynamic> json) => Publish(
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
  String subtitle;
  String authors;
  String publisher;
  int? publishedDate;
  String description;
  int? pageCount;
  String categories;
  String language;
  String previewLink;
  String cover;
  String isbn10;
  String isbn13;
  DateTime dateAdded;
  bool isVerified;
  bool isValid;

  Fields({
    required this.user,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.pageCount,
    required this.categories,
    required this.language,
    required this.previewLink,
    required this.cover,
    required this.isbn10,
    required this.isbn13,
    required this.dateAdded,
    required this.isVerified,
    required this.isValid,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        subtitle: json["subtitle"],
        authors: json["authors"],
        publisher: json["publisher"],
        publishedDate: json["published_date"],
        description: json["description"],
        pageCount: json["page_count"],
        categories: json["categories"],
        language: json["language"],
        previewLink: json["preview_link"],
        cover: json["cover"],
        isbn10: json["isbn_10"],
        isbn13: json["isbn_13"],
        dateAdded: DateTime.parse(json["date_added"]),
        isVerified: json["is_verified"],
        isValid: json["is_valid"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "subtitle": subtitle,
        "authors": authors,
        "publisher": publisher,
        "published_date": publishedDate,
        "description": description,
        "page_count": pageCount,
        "categories": categories,
        "language": language,
        "preview_link": previewLink,
        "cover": cover,
        "isbn_10": isbn10,
        "isbn_13": isbn13,
        "date_added": dateAdded.toIso8601String(),
        "is_verified": isVerified,
        "is_valid": isValid,
      };
}
