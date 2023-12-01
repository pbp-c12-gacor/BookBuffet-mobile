import 'package:bookbuffet/forum/screens/forum.dart';
import 'package:bookbuffet/home/home.dart';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  List<Widget> _widgetsOptions = <Widget>[
    MyHomePage(),
    ForumPage(),
  ];

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: onItemTap,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            backgroundColor: secondaryColor,
            color: primaryColor,
            activeColor: primaryColor,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.book,
                text: "Catalogue",
              ),
              GButton(
                icon: Icons.forum,
                text: "Forum",
              ),
              GButton(
                icon: Icons.person,
                text: "Profile",
              )
            ],
          ),
        ));
  }
}
