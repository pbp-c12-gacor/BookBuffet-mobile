import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class ForumPages extends StatefulWidget {
  const ForumPages({super.key});

  @override
  State<ForumPages> createState() => _ForumPagesState();
}

class _ForumPagesState extends State<ForumPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Buffet'),
        backgroundColor: secondaryColor,
      ),
      // body: ,
      bottomNavigationBar: const BottomBar(),
    );
  }
}
