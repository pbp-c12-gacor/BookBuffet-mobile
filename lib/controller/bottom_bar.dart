import 'package:bookbuffet/pages/catalog/main.dart';
import 'package:bookbuffet/pages/forum/screens/forum.dart';
import 'package:bookbuffet/pages/home/screens/home.dart';
import 'package:bookbuffet/pages/profile/profile.dart';
import 'package:get/get.dart';

class BottomBarController extends GetxController {
  RxInt index = 0.obs;
  var pages = [
    MyHomePage(),
    const CatalogPage(),
    const ForumPage(),
    const ProfilePage()
  ];
}
