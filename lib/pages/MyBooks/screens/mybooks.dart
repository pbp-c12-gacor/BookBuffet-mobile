import 'package:bookbuffet/pages/MyBooks/utils/mybook_card.dart';
import 'package:bookbuffet/pages/catalog/screens/catalog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:bookbuffet/pages/MyBooks/models/Mybook.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({Key? key}) : super(key: key);

  @override
  BookPageState createState() => BookPageState();
}

class BookPageState extends State<MyBooksPage> {
  Future<List<MyBook>>? booksFuture;
  @override
  void initState() {
    super.initState();
    booksFuture = getMyBooks(); // Initialize the future in initState
  }

  Future<List<MyBook>> getMyBooks() async {
    final request = context.watch<CookieRequest>();
    // print(request.jsonData);
    var response = await request
        .get('https://bookbuffet.onrender.com/MyBooks/get-my-books-json/');
    // print(response);
    String data = jsonEncode(response);

    if (response != null) {
      final books = myBookFromJson(data);
      // print(books.first);
      return books;
    } else {
      throw Exception('Failed');
    }
  }

  void refreshBooks() {
    setState(() {
      booksFuture = getMyBooks(); // Refresh the list of books
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
        appBar: AppBar(
          title: Text('My Books'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Catalog(),
                  ),
                );
              },
              icon: const Icon(Icons.book),
            ),
          ],
        ),
        body: FutureBuilder<List<MyBook>>(
            future: getMyBooks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<MyBook> books = snapshot.data!;
                return GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.8 / 1,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyBookCard(
                        book: books[index],

                        onBookDeleted: refreshBooks, // Pass the callback here
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong!'),
                );
                // return const Text('WOw');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
