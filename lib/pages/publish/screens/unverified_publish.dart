import 'package:bookbuffet/pages/publish/models/publish.dart';
import 'package:bookbuffet/pages/publish/screens/details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  static String baseApiUrl = 'https://bookbuffet.onrender.com';
  Future<List<Publish>> getUnverifiedPublish() async {
    final request = context.watch<CookieRequest>();
    var response =
        await request.get('$baseApiUrl/publish/get-unverified-publish/');
    String data = jsonEncode(response);
    if (response != null) {
      final books = publishFromJson(data);
      return books;
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
          title: const Center(child: Text('Unverified Books')),
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
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 8,
                            right: 16,
                            bottom: 8,
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(book.fields.title),
                              subtitle: FutureBuilder<String>(
                                future: getUserById(book.fields.user),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('Submitted by: ...');
                                  } else if (userSnapshot.hasError) {
                                    return const Text('Submitted by: -');
                                  } else {
                                    return Text(
                                        'Submitted by: ${userSnapshot.data}');
                                  }
                                },
                              ),
                              leading: CachedNetworkImage(
                                imageUrl:
                                    '$baseApiUrl/media/${book.fields.cover}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              onTap: () async {
                                var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                      bookPk: book.pk,
                                      isVerifiying: true,
                                    ),
                                  ),
                                );

                                if (result != null && result == true) {
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
      ),
    );
  }
}
