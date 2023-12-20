import 'package:bookbuffet/pages/MyBooks/models/Mybook.dart';
import 'package:bookbuffet/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookbuffet/pages/MyBooks/models/bookReview.dart';
import 'package:bookbuffet/pages/MyBooks/screens/reviews.dart';
// import 'package:bookbuffet/pages/catalog/utils/api_service.dart';
// import 'package:bookbuffet/pages/catalog/utils/user_api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class MyBookCard extends StatelessWidget {
  final MyBook book;
  late BookReview bookReview;
  final Function onBookDeleted; // Add this line

  MyBookCard({Key? key, required this.book, required this.onBookDeleted})
      : super(key: key); // Modify this line

  Future<List<BookReview>> getBook(BuildContext context, int id) async {
    final request = context.watch<CookieRequest>();
    // print("SEPARATOR");
    final response = await request
        .get(('https://bookbuffet.onrender.com/MyBooks/get-book-json/$id/'));
    // print(response);
    // final response = await http
    //     .get(Uri.parse('https://bookbuffet.onrender.com/api/books/10/'));
    String data = jsonEncode(response);

    // print(data);

    // ignore: unnecessary_null_comparison
    // if (data != null) {
    final books = bookReviewFromJson(data);
    // Book book = books[0];
    // print("SEPARATOR2");
    // print(books);
    // print("SEPARATOR3");
    // print(book);
    return books;
    // } else {
    //   throw Exception('Failed to load book');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl:
                  "https://bookbuffet.onrender.com/media/" + book.fields.cover,
              fit: BoxFit.fitHeight,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            // SizedBox(width: 10, height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(book.fields.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            // ElevatedButton(
            //   child: Text('Go to Review'),
            //   onPressed: () {
            //     // Implement save for later functionality
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ReviewPage(book: bookReview),
            //       ),
            //     );
            //   },
            // ),
            ElevatedButton(
              child: Text('Go to Review'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<BookReview>>(
                      future: getBook(context, book.pk),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<BookReview> books = snapshot.data!;
                          return ReviewPage(book: books[0]);
                        }
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        // return CircularProgressIndicator();
                        else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                          //
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final request =
                    Provider.of<CookieRequest>(context, listen: false);

                final response = await request.postJson(
                  'https://bookbuffet.onrender.com/MyBooks/delete-mybooks-flutter/${book.pk}/',
                  jsonEncode({
                    "book_id": book.pk,
                  }),
                );
                onBookDeleted();
                showCustomSnackBar(context, "Book is deleted successfully");
              },
            ),
          ],
        ),
      ),
    );
  }
}
