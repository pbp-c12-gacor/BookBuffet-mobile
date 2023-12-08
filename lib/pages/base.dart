import 'package:bookbuffet/controller/bottom_bar.dart';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/home/screens/home.dart';
import 'package:bookbuffet/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasePage extends StatefulWidget {
  final int initialIndex;

  const BasePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    BottomBarController controller = Get.put(BottomBarController());
    return Obx(() => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Container(
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor,
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: AppBar(
                title: Text(
                  'Book Buffet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
              ),
            ),
          ),
          body: controller.pages[controller.index.value],
          bottomNavigationBar: BottomBar(),
        ));
  }
}
