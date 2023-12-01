import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/widgets/bottom_bar.dart';
import 'package:bookbuffet/widgets/left-drawer.dart';
import 'package:bookbuffet/widgets/menu-card.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final List<MenuItem> items = [
    MenuItem("Forum", Icons.forum, Colors.orange.shade300),
    MenuItem("My Books", Icons.book, Colors.orange.shade500),
    MenuItem("Catalog", Icons.view_list, Colors.orange.shade700),
    MenuItem("Publish Book", Icons.publish, Colors.orange.shade700),
    MenuItem("Report Book", Icons.report, Colors.orange.shade700),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Buffet',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                'Book Buffet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3, // Anda bisa mengubah nilai ini
                children: items.map((MenuItem item) {
                  return MenuCard(item);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
