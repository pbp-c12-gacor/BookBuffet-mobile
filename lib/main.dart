import 'package:bookbuffet/controller/bottom_bar.dart';
import 'package:bookbuffet/pages/base.dart';
import 'package:bookbuffet/pages/home/screens/login.dart';
import 'package:bookbuffet/pages/home/screens/welcome_screen.dart';
import 'package:bookbuffet/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

const primaryColor = Color(0xfff3f2ec);
const secondaryColor = Color(0xffc4a992);

void main() async {
  Get.put(BottomBarController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) {
          CookieRequest request = CookieRequest();
          return request;
        },
        child: MaterialApp(
          title: 'Book Buffet',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            useMaterial3: true,
          ),

          // home: LoginPage(),
          // home: RegisterPage(),
          home: WelcomeScreen(),
          // home: ProfilePage(),
        ));
  }
}
