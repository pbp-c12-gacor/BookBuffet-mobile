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
    controller.index.value = widget.initialIndex;
    return Obx(() => Scaffold(
          body: controller.pages[controller.index.value],
          bottomNavigationBar: BottomBar(
            initialIndex: 0,
          ),
        ));
  }
}
