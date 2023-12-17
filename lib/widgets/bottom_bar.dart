import 'package:bookbuffet/controller/bottom_bar.dart';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatelessWidget {
  final int initialIndex;
  const BottomBar({key, this.initialIndex = 0}) : super(key: key);
  Widget build(BuildContext context) {
    BottomBarController controller = Get.find();
    return Container(
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: primaryColor,
              spreadRadius: 2,
              blurRadius: 1,
              offset: Offset(2, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            backgroundColor: secondaryColor,
            color: primaryColor,
            onTabChange: (value) => {controller.index.value = value},
            activeColor: primaryColor,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            selectedIndex: controller.index.value,
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
