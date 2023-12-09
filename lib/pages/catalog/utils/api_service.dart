import 'dart:convert';
import 'package:bookbuffet/pages/catalog/models/author.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/category.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseApiUrl = 'https://bookbuffet.onrender.com/api';

  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(baseApiUrl + '/books'));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Author>> getAuthors() async {
    final response = await http.get(Uri.parse(baseApiUrl + '/authors'));
    if (response.statusCode == 200) {
      List<Author> authors = authorFromJson(response.body);
      return authors;
    } else {
      throw Exception('Failed to load authors');
    }
  }

  static Future<List<Category>> getCategories() async {
    final response =
        await http.get(Uri.parse(baseApiUrl + '/categories'));
    if (response.statusCode == 200) {
      List<Category> categories = categoryFromJson(response.body);
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<Book> getBook(int id) async {
    final response =
        await http.get(Uri.parse(baseApiUrl + '/books/' + id.toString()));
    if (response.statusCode == 200) {
      Book book = Book.fromJson(json.decode(response.body));
      return book;
    } else {
      throw Exception('Failed to load book');
    }
  }

  static Future<Author> getAuthor(int id) async {
    final response =
        await http.get(Uri.parse(baseApiUrl + '/authors/' + id.toString()));
    if (response.statusCode == 200) {
      Author author = Author.fromJson(json.decode(response.body));
      return author;
    } else {
      throw Exception('Failed to load author');
    }
  }

  static Future<Category> getCategory(int id) async {
    final response =
        await http.get(Uri.parse(baseApiUrl + '/categories/' + id.toString()));
    if (response.statusCode == 200) {
      Category category = Category.fromJson(json.decode(response.body));
      return category;
    } else {
      throw Exception('Failed to load category');
    }
  }

  static Future<List<Book>> getBooksByAuthor(int id) async {
    final response = await http
        .get(Uri.parse(baseApiUrl + '/authors/' + id.toString() + '/books'));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> getBooksByCategory(int id) async {
    final response = await http.get(
        Uri.parse(baseApiUrl + '/categories/' + id.toString() + '/books'));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> getBooksByAuthorAndCategory(
      int authorId, int categoryId) async {
    final response = await http.get(Uri.parse(baseApiUrl +
        '/authors/' +
        authorId.toString() +
        '/categories/' +
        categoryId.toString() +
        '/books'));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> searchBooks(String query) async {
    final response = await http.get(
        Uri.parse(baseApiUrl + '/search?search=' + query));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> searchBooksByTitle(String query) async {
    final response = await http.get(Uri.parse(
        baseApiUrl + '/search?search=title:' + query));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> searchBooksByAuthor(String query) async {
    final response = await http.get(Uri.parse(
        baseApiUrl + '/search?search=author:' + query));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> searchBooksByCategory(String query) async {
    final response = await http.get(Uri.parse(
        baseApiUrl + '/search?search=category:' + query));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> getRatings() async {
    final response = await http.get(Uri.parse(baseApiUrl + '/ratings'));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      return books;
    } else {
      throw Exception('Failed to load ratings');
    }
  }

  static Future<List<Rating>> getRatingsByBook(int id) async {
    final response =
        await http.get(Uri.parse(baseApiUrl + '/books/' + id.toString() + '/ratings'));
    if (response.statusCode == 200) {
      List<Rating> ratings = ratingFromJson(response.body);
      return ratings;
    } else {
      throw Exception('Failed to load ratings');
    }
  }
}