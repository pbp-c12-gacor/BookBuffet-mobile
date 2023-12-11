import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookbuffet/pages/home/screens/home.dart';
import 'dart:async';
import 'dart:convert';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController authorsController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController publishedDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pageCountController = TextEditingController();
  TextEditingController categoriesController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController previewLinkController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController isbn10Controller = TextEditingController();
  TextEditingController isbn13Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Buffet'),
        backgroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Publish Your Book Here!",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Type your book title here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Subtitle',
                    hintText: 'Type your book subtitle here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the subtitle';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: authorsController,
                  decoration: const InputDecoration(
                    labelText: 'Authors',
                    hintText: 'Seperate each Authors with Comma (,)',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the authors';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: publisherController,
                  decoration: const InputDecoration(
                    labelText: 'Publisher',
                    hintText: 'Type your book publisher here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the publisher';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: publishedDateController,
                  decoration: const InputDecoration(
                    labelText: 'Published Date',
                    hintText: 'Enter the year number',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the published date';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter with digits';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Please enter a valid published date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Type your book description here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: pageCountController,
                  decoration: const InputDecoration(
                    labelText: 'Page Count',
                    hintText: 'Type your book page count here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the page count';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter with digits';
                    }
                    if (int.parse(value) <= 0) {
                      return 'Please enter a valid page count';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: categoriesController,
                  decoration: const InputDecoration(
                    labelText: 'Categories',
                    hintText: 'Separate each categories with Comma (,)',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the categories';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: languageController,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    hintText: 'Type your book language here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the categories';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: previewLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Preview Link',
                    hintText: 'Type your book preview link here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the preview link';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  // Harus diganti buat minta input file
                  controller: coverController,
                  decoration: const InputDecoration(
                    labelText: 'Cover',
                    hintText: 'Upload your book cover here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the cover';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: previewLinkController,
                  decoration: const InputDecoration(
                    labelText: 'ISBN 10',
                    hintText: 'Type your book ISBN 10 here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ISBN 10';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: previewLinkController,
                  decoration: const InputDecoration(
                    labelText: 'ISBN 13',
                    hintText: 'Type your book ISBN 13 here',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ISBN 13';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "http://127.0.0.1:8000/publish/create-publish-flutter/",
                        jsonEncode(<String, dynamic>{
                          'title': titleController.text,
                          'subtitle': subtitleController.text,
                          'authors': authorsController.text,
                          'publisher': publisherController.text,
                          'published_date':
                              int.parse(publishedDateController.text),
                          'description': descriptionController.text,
                          'page_count': int.parse(pageCountController.text),
                          'categories': categoriesController.text,
                          'language': languageController.text,
                          'preview_link': previewLinkController.text,
                          'cover': coverController.text,
                          'isbn_10': isbn10Controller.text,
                          'isbn_13': isbn13Controller.text,
                        }),
                      );

                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Your book has been published! Please wait for forward confirmation."),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Oops, something went wrong"),
                        ));
                      }

                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text('Click Here to Publish!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
