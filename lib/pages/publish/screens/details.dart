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
  Future<Publish> getBook() async {
    final request = context.watch<CookieRequest>();
    final int pk = widget.bookPk;
    var response =
        await request.get('http://127.0.0.1:8000/publish/get-publish/$pk/');
    String data = jsonEncode(response);
    if (response != null) {
      final book = publishFromJson(data);
      return book.first; // Ambil elemen index pertama
    } else {
      throw Exception('Failed');
    }
  }

  Future<String> getUserById(int userId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/report/get-user/$userId/'));
    if (response.statusCode == 200) {
      var user = jsonDecode(utf8.decode(response.bodyBytes))[0];
      return user['fields']['username'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
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

            return FutureBuilder<String>(
              future: getUserById(book.fields.user),
              builder: (context, AsyncSnapshot<String> userSnapshot) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'http://127.0.0.1:8000/media/${book.fields.cover}',
                          fit: BoxFit.cover,
                          width: 400.0,
                          height: 400.0,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, size: 200.0),
                        ),
                        const SizedBox(height: 16),
                        // Book Details
                        Text(
                          'Title: ${book.fields.title}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text('Authors: ${book.fields.authors}'),
                        const SizedBox(height: 8),

                        Text(
                          'Publisher: ${(book.fields.publisher.isNotEmpty) ? book.fields.publisher : '-'}',
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Published Date: ${book.fields.publishedDate ?? '-'}',
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Description: ${(book.fields.description.isNotEmpty) ? book.fields.description : '-'}',
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Page Count: ${book.fields.pageCount ?? '-'}',
                        ),
                        const SizedBox(height: 8),

                        Text('Categories: ${book.fields.categories}'),
                        const SizedBox(height: 8),

                        Text(
                          'Language: ${book.fields.language.isNotEmpty ? book.fields.language : '-'}',
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'ISBN-10: ${book.fields.isbn10.isNotEmpty ? book.fields.isbn10 : '-'}',
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'ISBN-13: ${book.fields.isbn13.isNotEmpty ? book.fields.isbn13 : '-'}',
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Submitted By: ${userSnapshot.data}',
                        ),
                        const SizedBox(height: 8),

                        Text(
                          'Date Added: $date',
                        ),
                        const SizedBox(height: 8),

                        if (widget.isVerifiying)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // Show a confirmation dialog before rejecting
                                  bool shouldAccept = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Are you sure you want to accept this book?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(true); // User confirmed
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(false); // User canceled
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (shouldAccept) {
                                    int pk = book.pk;
                                    bool confirmation = true;

                                    String url =
                                        'http://127.0.0.1:8000/publish/confirming-publish/$pk/';

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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Accepted a book!",
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Oops, something went wrong",
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Accept'),
                              ),
                              const SizedBox(
                                  width:
                                      16), // Add some space between the buttons
                              ElevatedButton(
                                onPressed: () async {
                                  // Show a confirmation dialog before rejecting
                                  bool shouldReject = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                            'Are you sure you want to reject this book?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(true); // User confirmed
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(false); // User canceled
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // If the user confirmed, proceed with rejection
                                  if (shouldReject) {
                                    int pk = book.pk;
                                    bool confirmation = false;

                                    String url =
                                        'http://127.0.0.1:8000/publish/confirming-publish/$pk/';

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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Rejected a book!"),
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Oops, something went wrong"),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Reject'),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
