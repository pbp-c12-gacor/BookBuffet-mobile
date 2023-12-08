import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';

class PublishPage extends StatelessWidget {
  const PublishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Buffet'),
        backgroundColor: secondaryColor,
      ),
      body: Column(
        children: [Text("Publish")],
      ),
    );
  }
}
