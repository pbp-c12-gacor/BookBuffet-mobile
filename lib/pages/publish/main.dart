import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController previewLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Buffet'),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text("Publish"),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: subtitleController,
                decoration: InputDecoration(labelText: 'Subtitle'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subtitle';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: previewLinkController,
                decoration: InputDecoration(labelText: 'Preview Link'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the preview link';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    String title = titleController.text;
                    String subtitle = subtitleController.text;
                    String author = authorController.text;
                    String previewLink = previewLinkController.text;
                  }
                },
                child: const Text('Publish Your Book Here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
