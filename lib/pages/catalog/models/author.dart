// To parse this JSON data, do
//
//     final author = authorFromJson(jsonString);

import 'dart:convert';

List<Author> authorFromJson(String str) => List<Author>.from(json.decode(str).map((x) => Author.fromJson(x)));

String authorToJson(List<Author> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Author {
    int id;
    String name;

    Author({
        required this.id,
        required this.name,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
