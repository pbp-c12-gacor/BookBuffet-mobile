import 'package:bookbuffet/forum/forum.dart';
import 'package:bookbuffet/home/home.dart';
import 'package:bookbuffet/home/screens/login.dart';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ForumPage()),
              );
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
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text('Log out',
                style: TextStyle(color: Colors.black, fontSize: 18)),
            onTap: () async {
              final response =
                  await request.logout("http://127.0.0.1:8000/auth/logout/");
              String message = response["message"];
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message"),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
