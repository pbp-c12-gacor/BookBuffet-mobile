// To parse this JSON data, do
//
//     final myBooks = myBooksFromJson(jsonString);

import 'dart:convert';

List<MyBooks> myBooksFromJson(String str) => List<MyBooks>.from(json.decode(str).map((x) => MyBooks.fromJson(x)));

String myBooksToJson(List<MyBooks> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyBooks {
    String model;
    int pk;
    Fields fields;

    MyBooks({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory MyBooks.fromJson(Map<String, dynamic> json) => MyBooks(
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
    String title;
    String subtitle;
    String publisher;
    int publishedDate;
    String description;
    int pageCount;
    String language;
    String previewLink;
    String cover;
    String isbn10;
    String isbn13;
    List<int> authors;
    List<int> categories;

    Fields({
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
        required this.authors,
        required this.categories,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        subtitle: json["subtitle"],
        publisher: json["publisher"],
        publishedDate: json["published_date"],
        description: json["description"],
        pageCount: json["page_count"],
        language: json["language"],
        previewLink: json["preview_link"],
        cover: json["cover"],
        isbn10: json["isbn_10"],
        isbn13: json["isbn_13"],
        authors: List<int>.from(json["authors"].map((x) => x)),
        categories: List<int>.from(json["categories"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
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
        "authors": List<dynamic>.from(authors.map((x) => x)),
        "categories": List<dynamic>.from(categories.map((x) => x)),
    };
}
