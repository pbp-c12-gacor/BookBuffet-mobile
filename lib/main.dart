import 'package:bookbuffet/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const color = Color(0xfff3f2ec);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Buffet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: color),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
