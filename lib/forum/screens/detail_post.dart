import 'dart:convert';
import 'package:bookbuffet/forum/models/comment.dart';
import 'package:bookbuffet/forum/models/post.dart';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DetailPostPage extends StatefulWidget {
  final Post post;
  final String username;

  DetailPostPage({required this.post, required this.username});

  @override
  _DetailPostPageState createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  String _comment = "";
  bool _isFormVisible = false;

  Future<List<Comment>> fetchComment() async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/forum/get-comments/${widget.post.pk}/');
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Comment> listComment = [];
    for (var d in data) {
      if (d != null) {
        listComment.add(Comment.fromJson(d));
      }
    }
    return listComment;
  }

  Future<String> getUserById(String userId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/forum/get-user/$userId/'));
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes))[0]['fields']
          ['username'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Buffet"),
        backgroundColor: secondaryColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.post.fields.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.post.fields.text,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.black), // tambahkan garis pembatas
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<Comment>>(
                    future: fetchComment(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<String>(
                              future: getUserById(
                                  snapshot.data![index].fields.user.toString()),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (userSnapshot.hasError) {
                                  return Text('Error: ${userSnapshot.error}');
                                } else {
                                  return ListTile(
                                    title: Text(
                                      snapshot.data![index].fields.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'By ${userSnapshot.data}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: _isFormVisible ? 20.0 : 0.0),
              child: TextField(
                onTap: () {
                  setState(() {
                    _isFormVisible = true;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Add a comment',
                  suffixIcon: _isFormVisible
                      ? IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            // Handle comment submission
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
