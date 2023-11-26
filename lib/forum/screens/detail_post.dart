import 'dart:async';
import 'dart:convert';
import 'package:bookbuffet/forum/models/comment.dart';
import 'package:bookbuffet/forum/models/post.dart';
import 'package:bookbuffet/forum/screens/comment_form.dart';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DetailPostPage extends StatefulWidget {
  final Post post;
  final Map<String, dynamic> currUser;

  DetailPostPage({required this.post, required this.currUser});

  @override
  _DetailPostPageState createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  String _comment = "";
  final _formKey = GlobalKey<FormState>();
  final _formFocusNode = FocusNode();
  final _refreshController = StreamController<void>.broadcast();

  Stream<List<Comment>> fetchComment() async* {
    while (true) {
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
      yield listComment.reversed.toList();

      // Tunggu sinyal refresh
      await _refreshController.stream.first;
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/forum/get-user/$userId/'));
    if (response.statusCode == 200) {
      var user = jsonDecode(utf8.decode(response.bodyBytes))[0];
      return {'id': user['pk'], 'username': user['fields']['username']};
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.currUser["username"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.currUser["id"] ==
                                widget.post.fields.user)
                              PopupMenuButton<int>(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text("Edit"),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Text("Delete"),
                                  ),
                                ],
                                onSelected: (value) {
                                  // Handle your logic here
                                },
                              ),
                          ],
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
                      ],
                    ),
                  ),
                ),
                Text("Comments"),
                Expanded(
                    child: StreamBuilder<List<Comment>>(
                  stream: fetchComment(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Comment>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<Map<String, dynamic>>(
                            future: getUserById(
                                snapshot.data![index].fields.user.toString()),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (userSnapshot.hasError) {
                                return Text('Error: ${userSnapshot.error}');
                              } else {
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      snapshot.data![index].fields.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'By ${userSnapshot.data!['username']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    trailing: userSnapshot.data!['id'] ==
                                            widget.currUser["id"]
                                        ? PopupMenuButton<int>(
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 1,
                                                child: Text("Edit"),
                                              ),
                                              PopupMenuItem(
                                                value: 2,
                                                child: Text("Delete"),
                                              ),
                                            ],
                                            onSelected: (value) {
                                              // Handle your logic here
                                            },
                                          )
                                        : null,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ))
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              child: CommentForm(
                postId: widget.post.pk.toString(),
                onCommentChanged: (String comment) {},
                focusNode: _formFocusNode,
                refreshController: _refreshController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
