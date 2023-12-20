import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/publish/models/publish.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DetailsPage extends StatefulWidget {
  final int bookPk;
  final bool isVerifiying;

  const DetailsPage({
    Key? key,
    required this.bookPk,
    required this.isVerifiying,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String baseApiUrl = 'https://bookbuffet.onrender.com';

  Future<Publish> getBook() async {
    final request = context.watch<CookieRequest>();
    final int pk = widget.bookPk;
    var response = await request.get('$baseApiUrl/publish/get-publish/$pk/');
    String data = jsonEncode(response);
    if (response != null) {
      final book = publishFromJson(data);
      return book.first; // Ambil elemen index pertama
    } else {
      throw Exception('Failed');
    }
  }

  Future<String> getUserById(int userId) async {
    final response =
        await http.get(Uri.parse('$baseApiUrl/report/get-user/$userId/'));
    if (response.statusCode == 200) {
      var user = jsonDecode(utf8.decode(response.bodyBytes))[0];
      return user['fields']['username'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Book Details',
            ),
          ),
        ),
        body: FutureBuilder<Publish>(
          future: getBook(),
          builder: (context, AsyncSnapshot<Publish> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final Publish book = snapshot.data!;
              String date = book.fields.dateAdded.toString().split(" ").first;

              return buildBookDetails(book, date);
            }
          },
        ),
      ),
    );
  }

  Widget buildBookDetails(Publish book, String date) {
    return FutureBuilder<String>(
      future: getUserById(book.fields.user),
      builder: (context, AsyncSnapshot<String> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (userSnapshot.hasError) {
          return Center(child: Text('Error: ${userSnapshot.error}'));
        } else {
          String user = userSnapshot.data!;

          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            children: [
              CachedNetworkImage(
                imageUrl: '$baseApiUrl/media/${book.fields.cover}',
                fit: BoxFit.cover,
                width: 400.0,
                height: 400.0,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 200.0),
              ),
              const SizedBox(height: 16),
              Text(
                'Title: ${book.fields.title}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Authors: ${book.fields.authors}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Publisher: ${(book.fields.publisher.isNotEmpty) ? book.fields.publisher : '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Published Date: ${book.fields.publishedDate ?? '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Description: ${(book.fields.description.isNotEmpty) ? book.fields.description : '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Page Count: ${book.fields.pageCount ?? '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Categories: ${book.fields.categories}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Language: ${book.fields.language.isNotEmpty ? book.fields.language : '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'ISBN-10: ${book.fields.isbn10.isNotEmpty ? book.fields.isbn10 : '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'ISBN-13: ${book.fields.isbn13.isNotEmpty ? book.fields.isbn13 : '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Submitted By: $user',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Date Added: $date',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              if (widget.isVerifiying) const SizedBox(height: 10),
              if (widget.isVerifiying)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            secondaryColor, // Replace with your color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 40,
                        ),
                      ),
                      onPressed: () async {
                        bool shouldAccept = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: secondaryColor,
                              title: const Text(
                                'Confirmation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                'Are you sure you want to accept this book?',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldAccept) {
                          int pk = book.pk;
                          bool confirmation = true;

                          String url =
                              '$baseApiUrl/publish/confirming-publish/$pk/';

                          var response = await http.post(
                            Uri.parse(url),
                            headers: {
                              'Content-Type':
                                  'application/x-www-form-urlencoded',
                            },
                            body: {
                              'verify': confirmation.toString(),
                            },
                          );

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Accepted a book!",
                                ),
                              ),
                            );
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Oops, something went wrong",
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 40,
                        ),
                      ),
                      onPressed: () async {
                        bool shouldReject = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: secondaryColor,
                              title: const Text(
                                'Confirmation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: const Text(
                                'Are you sure you want to reject this book?',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldReject) {
                          int pk = book.pk;
                          bool confirmation = false;

                          String url =
                              '$baseApiUrl/publish/confirming-publish/$pk/';

                          var response = await http.post(
                            Uri.parse(url),
                            headers: {
                              'Content-Type':
                                  'application/x-www-form-urlencoded',
                            },
                            body: {
                              'verify': confirmation.toString(),
                            },
                          );
                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Rejected a book!"),
                              ),
                            );
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Oops, something went wrong"),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }
}
