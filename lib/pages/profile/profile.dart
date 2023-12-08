import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/home/screens/login.dart';
import 'package:bookbuffet/pages/home/screens/register.dart';
import 'package:bookbuffet/pages/profile/models/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String username = "User";
    String initial = "U";

    // Jika tidak loggedIn, tampilkan username default dan inisial
    if (!request.loggedIn && request.jsonData.isNotEmpty) {
      username = request.jsonData["username"] ?? "User";
      initial = username.isNotEmpty ? username[0].toUpperCase() : "U";
    }

    return Scaffold(
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
                    backgroundColor: secondaryColor,
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
              Text(username, style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 20),

              // Tampilkan tombol "Sign In" dan "Sign Up" jika tidak loggedIn
              if (!request.loggedIn) ...[
                ProfileMenuWidget(
                    title: "Sign In",
                    icon: Icons.login,
                    onPress: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: "Sign Up",
                    icon: Icons.app_registration,
                    onPress: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    }),
                const SizedBox(height: 10),
              ] else ...[
                /// -- MENU
                ProfileMenuWidget(
                    title: "Report Book", icon: Icons.report, onPress: () {}),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: "My Books", icon: Icons.book, onPress: () {}),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: "Publish Book", icon: Icons.publish, onPress: () {}),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: "Logout",
                    icon: Icons.logout,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () async {
                      final response = await request
                          .logout("http://127.0.0.1:8000/auth/logout/");
                      String message = response["message"];
                      if (response['status']) {
                        String uname = response["username"];
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message Sampai jumpa, $uname."),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message"),
                        ));
                      }
                    }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
