import 'package:bookbuffet/forum/screens/forum.dart';
import 'package:bookbuffet/home/home.dart';
import 'package:bookbuffet/home/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

const primaryColor = Color(0xfff3f2ec);
const secondaryColor = Color(0xffc4a992);

void main() {
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
          home: LoginPage(),
          // home: MyHomePage(),
        ));
  }
}
