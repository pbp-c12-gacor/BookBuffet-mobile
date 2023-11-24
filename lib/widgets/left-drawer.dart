import 'package:bookbuffet/home/home.dart';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Book Buffet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Book Buffet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Colors.black),
            title: const Text('Halaman Utama',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.forum, color: Colors.black),
            title: const Text('Forum',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onTap: () {
              // Navigasi ke halaman Forum
            },
          ),
          ListTile(
            leading: const Icon(Icons.book, color: Colors.black),
            title: const Text('My Books',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onTap: () {
              // Navigasi ke halaman My Books
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_list, color: Colors.black),
            title: const Text('Catalog',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onTap: () {
              // Navigasi ke halaman Catalog
            },
          ),
          ListTile(
            leading: const Icon(Icons.publish, color: Colors.black),
            title: const Text('Publish Book',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onTap: () {
              // Navigasi ke halaman Publish Book
            },
          ),
          ListTile(
            leading: const Icon(Icons.report, color: Colors.black),
            title: const Text('Report Book',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onTap: () {
              // Navigasi ke halaman Report Book
            },
          ),
        ],
      ),
    );
  }
}
