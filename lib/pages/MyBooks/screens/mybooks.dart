import 'package:bookbuffet/pages/MyBooks/utils/mybook_card.dart';
import 'package:bookbuffet/pages/catalog/screens/catalog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:bookbuffet/pages/MyBooks/models/mybook.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({Key? key}) : super(key: key);

  @override
  BookPageState createState() => BookPageState();
}

class BookPageState extends State<MyBooksPage> {
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // Future<List<MyBook>> response = request
    //     .postJson("http://127.0.0.1:8000/MyBooks/get-mybooks/",
    //         jsonEncode(<String, String>{"Content-Type": "application/json"}))
    //     .then((value) {
    //   if (value == null) {
    //     return [];
    //   }
    //   print(response.body);
    //   var jsonValue = jsonDecode(value);
    //   List<MyBook> listMyBook = [];
    //   for (var data in jsonValue) {
    //     if (data != null) {
    //       listMyBook.add(MyBook.fromJson(data));
    //     }
    //   }
    //   return listMyBook;
    // });

    return Scaffold(
        appBar: AppBar(
          title: Text('My Books'),
          actions: [
            // Padding(
            //   padding: EdgeInsets.only(right: 20.0),
            //   child: Center(child: Text(' items')),
            // ),
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
                      child: MyBookCard(book: books[index]),
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
