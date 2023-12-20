import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/home/screens/login.dart';
import 'package:bookbuffet/pages/home/screens/register.dart';
import 'package:bookbuffet/pages/profile/models/profile_menu.dart';
import 'package:bookbuffet/pages/publish/screens/publish_options.dart';
import 'package:bookbuffet/pages/report/screens/show_reports.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static String baseApiUrl = 'https://bookbuffet.onrender.com';

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final response =
        await http.get(Uri.parse('$baseApiUrl/report/get-user/$userId/'));
    if (response.statusCode == 200) {
      var user = jsonDecode(utf8.decode(response.bodyBytes))[0];
      return {
        'id': user['pk'],
        'username': user['fields']['username'],
        'is_staff': user['fields']['is_staff']
      };
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String username = "User";
    String initial = "U";

    if (request.loggedIn && request.jsonData.isNotEmpty) {
      username = request.jsonData["username"] ?? "User";
      initial = username.isNotEmpty ? username[0].toUpperCase() : "U";
    }

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Bitmap.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    /// -- IMAGE
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: secondaryColor.withOpacity(0.7),
                          child: Text(
                            initial,
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(username,
                        style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 20),
                    if (!request.loggedIn) ...[
                      ProfileMenuWidget(
                          title: "Sign In",
                          icon: Icons.login,
                          onPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "Sign Up",
                          icon: Icons.app_registration,
                          onPress: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          }),
                      const SizedBox(height: 10),
                    ] else ...[
                      ProfileMenuWidget(
                          title: "Show Report",
                          icon: Icons.report_sharp,
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ShowReportsPage()),
                            );
                          }),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "Report Book",
                          icon: Icons.report,
                          onPress: () {}),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "My Books", icon: Icons.book, onPress: () {}),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                        title: "Publish Book",
                        icon: Icons.publish,
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PublishOptionPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                          title: "Logout",
                          icon: Icons.logout,
                          textColor: Colors.red,
                          endIcon: false,
                          onPress: () async {
                            final response = await request
                                .logout("$baseApiUrl/auth/logout/");
                            String message = response["message"];
                            if (response['status']) {
                              String uname = response["username"];
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("$message Sampai jumpa, $uname."),
                              ));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("$message"),
                              ));
                            }
                          }),
                    ],
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
