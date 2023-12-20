// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';
import 'package:bookbuffet/pages/catalog/models/author.dart';
import 'package:bookbuffet/pages/catalog/models/category.dart';

List<Book> bookFromJson(String str) =>
    List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
  int id;
  List<Author> authors;
  List<Category> categories;
  String title;
  String? subtitle;
  String? publisher;
  int? publishedDate;
  String? description;
  int? pageCount;
  String? language;
  String? previewLink;
  String cover;
  String? isbn10;
  String? isbn13;

  Book({
    required this.id,
    required this.authors,
    required this.categories,
    required this.title,
    required this.subtitle,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.pageCount,
    required this.language,
    required this.previewLink,
    required this.cover,
    required this.isbn10,
    required this.isbn13,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        authors:
            List<Author>.from(json["authors"].map((x) => Author.fromJson(x))),
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
        title: json["title"],
        subtitle: json["subtitle"],
        publisher: json["publisher"],
        publishedDate: json["published_date"],
        description: json["description"],
        pageCount: json["page_count"],
        language: json["language"].toUpperCase(),
        previewLink: json["preview_link"],
        cover: json["cover"],
        isbn10: json["isbn_10"],
        isbn13: json["isbn_13"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "authors": List<dynamic>.from(authors.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "title": title,
        "subtitle": subtitle,
        "publisher": publisher,
        "published_date": publishedDate,
        "description": description,
        "page_count": pageCount,
        "language": language,
        "preview_link": previewLink,
        "cover": cover,
        "isbn_10": isbn10,
        "isbn_13": isbn13,
      };
}
