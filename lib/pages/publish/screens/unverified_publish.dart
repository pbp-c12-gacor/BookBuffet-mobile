import 'package:bookbuffet/pages/publish/models/publish.dart';
import 'package:bookbuffet/pages/publish/screens/details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

class UnverifiedPublishPage extends StatefulWidget {
  const UnverifiedPublishPage({super.key});

  @override
  _UnverifiedPublishPageState createState() => _UnverifiedPublishPageState();
}

class _UnverifiedPublishPageState extends State<UnverifiedPublishPage> {
  Future<List<Publish>> getUnverifiedPublish() async {
    final request = context.watch<CookieRequest>();
    var response = await request
        .get('http://127.0.0.1:8000/publish/get-unverified-publish/');
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
      appBar: AppBar(
        title: const Text('Unverified Books'),
      ),
      body: FutureBuilder(
        future: getUnverifiedPublish(),
        builder: (context, AsyncSnapshot<List<Publish>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Publish> books = snapshot.data!;
            return (books.isNotEmpty)
                ? ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      Publish book = books[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            title: Text(book.fields.title),
                            subtitle: Text(
                              'Status: ${(!book.fields.isVerified) ? 'Not Confirmed' : (book.fields.isValid) ? 'Accepted' : 'Rejected'}',
                            ),
                            leading: CachedNetworkImage(
                              imageUrl:
                                  'http://127.0.0.1:8000/media/${book.fields.cover}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            onTap: () async {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    bookPk: book.pk,
                                    isVerifiying: true,
                                  ),
                                ),
                              );

                              // Handle the result, e.g., refresh the page if needed
                              if (result) {
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      );
                    },
                  )
                // ignore: prefer_const_constructors
                : Center(
                    child: const Text('There is nothing you need to verify.'),
                  );
          }
        },
      ),
    );
  }
}
