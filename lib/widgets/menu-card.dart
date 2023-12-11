import 'package:bookbuffet/pages/MyBooks/screens/mybooks.dart';
import 'package:bookbuffet/pages/catalog/main.dart';
import 'package:bookbuffet/pages/forum/screens/forum.dart';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/report/main.dart';
import 'package:bookbuffet/pages/publish/main.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final IconData icon;
  final Color color;

  MenuItem(this.name, this.icon, this.color);
}

class MenuCard extends StatelessWidget {
  final MenuItem item;

  const MenuCard(this.item, {Key? key}) : super(key: key); // Constructor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: secondaryColor,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () {
          if (item.name == "Forum") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ForumPage()));
          } else if (item.name == "My Books") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyBooksPage()));
          } else if (item.name == "Catalog") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CatalogPage()));
          } else if (item.name == "Publish Book") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PublishPage()));
          } else if (item.name == "Report Book") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ReportPage()));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 24.0, // Anda bisa mengubah nilai ini
                ),
                const SizedBox(height: 10),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
