import 'dart:convert';
import 'package:bookbuffet/pages/base.dart';
import 'package:http/http.dart' as http;

import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/home/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  String _booktitle = "";
  String _comment = "";
  late Future<List<String>> listJudulBuku;
  String _selectedBook = "";
  String input = "";
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  Future<Map<String, dynamic>> getBookById(String bookId) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/books/$bookId/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/report/get-user/$userId/'));
    if (response.statusCode == 200) {
      var user = jsonDecode(utf8.decode(response.bodyBytes))[0];
      return {'id': user['pk'], 'username': user['fields']['username']};
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<String>> searchBooks(String input) async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/search/?search=title:${input}'));
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<String> bookTitles = [];
    for (var a in data) {
      String bookTitle;
      if (a["title"] != null) {
        bookTitle = a["title"].toString();
        bookTitles.add(bookTitle);
      }
    }
    return bookTitles;
  }

  @override
  void initState() {
    super.initState();
    listJudulBuku = Future.value([]);
  }

  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Buffet'),
        backgroundColor: secondaryColor,
      ),
      body: Column(
        children: <Widget>[
          Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _controller2,
                          decoration: InputDecoration(
                              hintText: "Enter the Book's Title here",
                              labelText: "Book's Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              )),
                          onChanged: (String? value) {
                            setState(() {
                              _booktitle = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Book's title can't be empty!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter your comment here",
                              labelText: "Comment",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                              )),
                          onChanged: (String? value) {
                            setState(() {
                              _comment = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Comment can't be empty!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final response = await request.postJson(
                                    "http://127.0.0.1:8000/report/create-report-flutter/",
                                    jsonEncode(<String, String>{
                                      'book_title': _controller2.text,
                                      'comment': _comment,
                                    }));
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("New Report has been saved!"),
                                  ));
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BasePage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "There is an error, please try again."),
                                  ));
                                }
                              }
                            },
                            child: const Text(
                              "Report",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Forget your book's title? Search here",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                  )),
              onChanged: (String value) {
                setState(() {
                  _selectedBook = value;
                  if (value.length >= 2) {
                    listJudulBuku = searchBooks(value);
                  } else {
                    listJudulBuku = Future.value([]);
                  }
                });
              },
            ),
          ),
          FutureBuilder<List<String>>(
            future: listJudulBuku,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]),
                        onTap: () {
                          setState(() {
                            _selectedBook = snapshot.data![index];
                            _controller.text = _selectedBook;
                            _controller2.text = _selectedBook;
                            listJudulBuku = Future.value([]);
                          });
                        },
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
