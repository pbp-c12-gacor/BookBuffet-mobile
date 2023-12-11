// To parse this JSON data, do
//
//     final rating = ratingFromJson(jsonString);

import 'dart:convert';
import 'package:bookbuffet/pages/catalog/models/book.dart';

List<Rating> ratingFromJson(String str) =>
    List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

String ratingToJson(List<Rating> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
  String username;
  String review;
  int rating;
  DateTime dateAdded;
  Book book;

  Rating({
    required this.username,
    required this.review,
    required this.rating,
    required this.dateAdded,
    required this.book,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        username: json["username"],
        review: json["review"],
        rating: json["rating"],
        dateAdded: DateTime.parse(json["date_added"]),
        book: Book.fromJson(json["book"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "review": review,
        "rating": rating,
        "date_added":
            "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "book": book.toJson(),
      };
}
