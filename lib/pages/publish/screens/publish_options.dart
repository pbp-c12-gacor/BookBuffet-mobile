import 'package:bookbuffet/pages/profile/models/profile_menu.dart';
import 'package:bookbuffet/pages/publish/screens/main.dart';
import 'package:bookbuffet/pages/publish/screens/my_publish.dart';
import 'package:bookbuffet/pages/publish/screens/unverified_publish.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class PublishOptionPage extends StatefulWidget {
  const PublishOptionPage({super.key});

  @override
  _PublishOptionPageState createState() => _PublishOptionPageState();
}

class _PublishOptionPageState extends State<PublishOptionPage> {
  static String baseApiUrl = 'https://bookbuffet.onrender.com';

  Future<bool> getUserIsStaff() async {
    final request = context.watch<CookieRequest>();

    var response = await request.get('$baseApiUrl/publish/is-staff/');

    if (response != null) {
      // Access the 'is_staff' field
      bool isStaff = response['is_staff'];

      return isStaff;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load user is staff status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Publish Book',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: FutureBuilder<bool>(
          future: getUserIsStaff(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              bool isStaff = snapshot.data ?? false;

              return Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 16, left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileMenuWidget(
                      title: 'Publish a Book',
                      icon: Icons.publish,
                      onPress: () {
                        // Navigate to Publish a Book page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PublishPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    ProfileMenuWidget(
                      title: 'My Published Books',
                      icon: Icons.library_books,
                      onPress: () {
                        // Navigate to My Publish page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyPublishPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    if (isStaff)
                      ProfileMenuWidget(
                        title: 'Verify a Book',
                        icon: Icons.verified_sharp,
                        onPress: () {
                          // Navigate to Verify a Book page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UnverifiedPublishPage(),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
