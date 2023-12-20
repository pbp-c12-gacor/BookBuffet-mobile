import 'dart:async';
import 'dart:convert';
import 'package:bookbuffet/pages/forum/models/comment.dart';
import 'package:bookbuffet/pages/forum/models/post.dart';
import 'package:bookbuffet/pages/forum/widgets/comment_form.dart';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/forum/screens/forum.dart';
import 'package:bookbuffet/pages/forum/utils/time_difference_formatter.dart';
import 'package:bookbuffet/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DetailPostPage extends StatefulWidget {
  final Post post;
  final Map<String, dynamic> currUser;
  final void Function() refreshPost;

  DetailPostPage(
      {required this.post, required this.currUser, required this.refreshPost});

  @override
  _DetailPostPageState createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  String _comment = "";
  String _title = "";
  String _text = "";
  final _formKey = GlobalKey<FormState>();
  final _formFocusNode = FocusNode();
  final _refreshController = StreamController<void>.broadcast();
  static String baseApiUrl = 'https://bookbuffet.onrender.com';

  Stream<List<Comment>> fetchComment() async* {
    while (true) {
      var url = Uri.parse('$baseApiUrl/forum/get-comments/${widget.post.pk}/');
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
    final response =
        await http.get(Uri.parse('$baseApiUrl/forum/get-user/$userId/'));
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: secondaryColor.withOpacity(0.7),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${widget.currUser["username"]}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          " · ${formatTimeDifference(widget.post.fields.dateAdded)}",
                                      style: const TextStyle(
                                        fontSize:
                                            14.0, // Ukuran font lebih kecil dari username
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (request.jsonData["id"] ==
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
                                  onSelected: (value) async {
                                    if (value == 1) {
                                      _title = widget.post.fields.title;
                                      _text = widget.post.fields.text;
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        ),
                                        builder: (context) => Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              100,
                                          child: Scaffold(
                                            appBar: AppBar(
                                              leading: IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              actions: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          secondaryColor,
                                                    ),
                                                    child: const Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        final response =
                                                            await request
                                                                .postJson(
                                                          "$baseApiUrl/forum/edit-post-flutter/${widget.post.pk}/",
                                                          jsonEncode(<String,
                                                              String>{
                                                            'title': _title,
                                                            'text': _text,
                                                          }),
                                                        );
                                                        if (response[
                                                                'status'] ==
                                                            'success') {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  "Post berhasil diperbarui!"),
                                                            ),
                                                          );
                                                          setState(() {
                                                            widget.post.fields
                                                                .title = _title;
                                                            widget.post.fields
                                                                .text = _text;
                                                          });
                                                          widget.refreshPost();
                                                          Navigator.pop(
                                                              context); // Menutup modal
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  "Terdapat kesalahan, silakan coba lagi."),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            body: Form(
                                              key: _formKey,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none, // hilangkan border
                                                              ),
                                                              hintText:
                                                                  'Type Your Title Here',
                                                              hintStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .grey, // ganti dengan warna yang Anda inginkan
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            initialValue: widget
                                                                .post
                                                                .fields
                                                                .title,
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _title = value!;
                                                              });
                                                            },
                                                            validator: (String?
                                                                value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Nama tidak boleh kosong!";
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          const Divider(
                                                              color:
                                                                  secondaryColor), // tambahkan garis pembatas
                                                          TextFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none, // hilangkan border
                                                              ),
                                                              hintText:
                                                                  "What's Happening?",
                                                              hintStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .grey, // ganti dengan warna yang Anda inginkan
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            maxLines: 5,
                                                            initialValue: widget
                                                                .post
                                                                .fields
                                                                .text,
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _text = value!;
                                                              });
                                                            },
                                                            validator: (String?
                                                                value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return "Nama tidak boleh kosong!";
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Lakukan operasi delete
                                      String id = widget.post.pk.toString();
                                      final response = await http.delete(
                                        Uri.parse(
                                            '$baseApiUrl/forum/delete-post/$id/'),
                                        headers: <String, String>{
                                          'Content-Type':
                                              'application/json; charset=UTF-8',
                                        },
                                      );
                                      if (response.statusCode == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Post berhasil dihapus!"),
                                          ),
                                        );
                                        widget.refreshPost();
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Terdapat kesalahan, silakan coba lagi."),
                                          ),
                                        );
                                      }
                                    }
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
                  Text(
                    "Comments",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
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
                                  return Container(
                                    margin: EdgeInsets.only(
                                        bottom: 20.0, left: 10.0, right: 10.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                      trailing:
                                          userSnapshot.data!['id'] ==
                                                  request.jsonData["id"]
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
                                                  onSelected: (value) async {
                                                    if (value == 1) {
                                                      _text = snapshot
                                                          .data![index]
                                                          .fields
                                                          .text;
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        clipBehavior: Clip
                                                            .antiAliasWithSaveLayer,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        builder: (context) =>
                                                            Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height -
                                                              100,
                                                          child: Scaffold(
                                                            appBar: AppBar(
                                                              leading:
                                                                  IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .close),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              actions: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          secondaryColor,
                                                                    ),
                                                                    child:
                                                                        const Text(
                                                                      'Edit',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      if (_formKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        final response =
                                                                            await request.postJson(
                                                                          "$baseApiUrl/forum/edit-comment-flutter/${snapshot.data![index].pk}/",
                                                                          jsonEncode(<String,
                                                                              String>{
                                                                            'title':
                                                                                _title,
                                                                            'text':
                                                                                _text,
                                                                          }),
                                                                        );
                                                                        if (response['status'] ==
                                                                            'success') {
                                                                          showCustomSnackBar(
                                                                              context,
                                                                              "Post is successfully updated");
                                                                          setState(
                                                                              () {
                                                                            fetchComment(); // Memanggil fetchPost lagi untuk memperbarui daftar post
                                                                          });
                                                                          Navigator.pop(
                                                                              context); // Menutup modal
                                                                        } else {
                                                                          showCustomSnackBar(
                                                                              context,
                                                                              "Oops, something went wrong");
                                                                        }
                                                                      }
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            body: Form(
                                                              key: _formKey,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          TextFormField(
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              border: UnderlineInputBorder(
                                                                                borderSide: BorderSide.none,
                                                                              ),
                                                                              hintText: "What's Happening?",
                                                                              hintStyle: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            maxLines:
                                                                                5,
                                                                            initialValue:
                                                                                snapshot.data![index].fields.text,
                                                                            onChanged:
                                                                                (String? value) {
                                                                              setState(() {
                                                                                _text = value!;
                                                                              });
                                                                            },
                                                                            validator:
                                                                                (String? value) {
                                                                              if (value == null || value.isEmpty) {
                                                                                return "Content cannot be empty";
                                                                              }
                                                                              return null;
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      String id = snapshot
                                                          .data![index].pk
                                                          .toString();
                                                      final response =
                                                          await http.delete(
                                                        Uri.parse(
                                                            '$baseApiUrl/forum/delete-comment/$id/'),
                                                        headers: <String,
                                                            String>{
                                                          'Content-Type':
                                                              'application/json; charset=UTF-8',
                                                        },
                                                      );
                                                      if (response.statusCode ==
                                                          200) {
                                                        showCustomSnackBar(
                                                            context,
                                                            "Comment is deleted successfully");
                                                        setState(() {
                                                          fetchComment(); // Memanggil fetchPost lagi untuk memperbarui daftar post
                                                        });
                                                      } else {
                                                        showCustomSnackBar(
                                                            context,
                                                            "Oops, something went wrong");
                                                      }
                                                    }
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
                child: request.loggedIn
                    ? CommentForm(
                        postId: widget.post.pk.toString(),
                        onCommentChanged: (String comment) {},
                        focusNode: _formFocusNode,
                        refreshController: _refreshController,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
