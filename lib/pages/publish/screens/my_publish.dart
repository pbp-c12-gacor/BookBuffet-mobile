import 'package:bookbuffet/pages/publish/models/publish.dart';
import 'package:bookbuffet/pages/publish/screens/details.dart';
import 'package:bookbuffet/pages/publish/screens/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

class MyPublishPage extends StatefulWidget {
  const MyPublishPage({super.key});

  @override
  _MyPublishPageState createState() => _MyPublishPageState();
}

class _MyPublishPageState extends State<MyPublishPage> {
  Future<List<Publish>> getMyPublish() async {
    final request = context.watch<CookieRequest>();
    var response =
        await request.get('http://127.0.0.1:8000/publish/get-publish/');
    String data = jsonEncode(response);
    if (response != null) {
      final books = publishFromJson(data);
      return books;
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            ),
            Expanded(
              child: FutureBuilder(
                future: getMyPublish(),
                builder: (context, AsyncSnapshot<List<Publish>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<Publish> books = snapshot.data!;
                    return (books.isEmpty)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Center(
                                child: Text(
                                  "You haven't publish a book.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PublishPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Tap here to publish a new one!',
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              Publish book = books[index];
                              return SizedBox(
                                width: 100.0,
                                height: 150.0,
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10.0),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsPage(
                                            bookPk: book.pk,
                                            isVerifiying: false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                'http://127.0.0.1:8000/media/${book.fields.cover}',
                                            fit: BoxFit.cover,
                                            width:
                                                80.0, // Adjust the width as needed
                                            height:
                                                80.0, // Adjust the height as needed
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error,
                                                        size: 80.0),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            book.fields.title.length > 20
                                                ? '${book.fields.title.substring(0, 20)}... (tap to see details)'
                                                : book.fields.title,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              children: [
                                                const TextSpan(
                                                    text: 'Status: '),
                                                TextSpan(
                                                  text: (!book
                                                          .fields.isVerified)
                                                      ? 'Not Confirmed'
                                                      : (book.fields.isValid)
                                                          ? 'Accepted'
                                                          : 'Rejected',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold, // Customize the boldness
                                                    color: (!book
                                                            .fields.isVerified)
                                                        ? Colors
                                                            .black // Not Confirmed (Yellow)
                                                        : (book.fields.isValid)
                                                            ? Colors
                                                                .green // Accepted (Green)
                                                            : Colors
                                                                .red, // Rejected (Red)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
