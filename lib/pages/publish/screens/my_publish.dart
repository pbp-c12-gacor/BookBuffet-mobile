import 'package:bookbuffet/controller/bottom_bar.dart';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/publish/models/publish.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bookbuffet/pages/base.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

class MyPublishPage extends StatefulWidget {
  const MyPublishPage({super.key});

  @override
  _MyPublishPageState createState() => _MyPublishPageState();
}

class _MyPublishPageState extends State<MyPublishPage> {
  Future<List<Publish>> getMyBooks() async {
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
    return Material(
      child: FutureBuilder(
        future: getMyBooks(),
        builder: (context, AsyncSnapshot<List<Publish>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Publish> books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                Publish book = books[index];
                return ListTile(
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
