import 'package:bookbuffet/pages/forum/models/comment.dart';
import 'package:bookbuffet/pages/forum/models/post.dart';
import 'package:bookbuffet/pages/forum/screens/detail_post.dart';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/forum/utils/time_difference_formatter.dart';
import 'package:bookbuffet/pages/forum/widgets/category_dropdown.dart';
import 'package:bookbuffet/pages/forum/widgets/book_dropdown.dart';
import 'package:bookbuffet/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  ForumPageState createState() => ForumPageState();
}

class ForumPageState extends State<ForumPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _text = "";
  List<Post> posts = [];
  int? IdBookSelected;
  late Future<List<Post>> initialFetch;
  static String baseApiUrl = 'https://bookbuffet.onrender.com';

  Future<Map<String, dynamic>> getBookById(String bookId) async {
    final response =
        await http.get(Uri.parse('$baseApiUrl/api/books/$bookId/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load book');
    }
  }

  void onCategoryChanged(String? category) async {
    var newPosts = await fetchPost(category);
    setState(() {
      posts = newPosts;
    });
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

  void handleBookSelected(int? book) {
    IdBookSelected = book;
  }

  void refreshPosts() async {
    posts = await fetchPost(null);
    setState(() {});
  }

  Future<List<Comment>> getCommentsByPostId(String postId) async {
    final response =
        await http.get(Uri.parse('$baseApiUrl/forum/get-comments/$postId/'));
    if (response.statusCode == 200) {
      List<Comment> comments = (json.decode(response.body) as List)
          .map((data) => Comment.fromJson(data))
          .toList();
      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<Post>> fetchPost(String? category) async {
    var url = Uri.parse('$baseApiUrl/forum/post/json/');
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    posts = [];
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    for (var d in data) {
      String? bookCategory;
      if (d["fields"]["book"] != null) {
        var book = await getBookById(d["fields"]["book"].toString());
        bookCategory = book["categories"][0]["name"].toString();
      }
      if (d != null && (bookCategory == category || category == null)) {
        var comments = await getCommentsByPostId(d["pk"].toString());
        d["commentCount"] = comments.length;

        posts.add(Post.fromJson(d));
      }
    }
    posts = posts.reversed.toList();
    return posts;
  }

  @override
  void initState() {
    super.initState();
    initialFetch = fetchPost(null);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: FutureBuilder<List<Post>>(
            future: initialFetch,
            builder: (context, AsyncSnapshot<List<Post>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data post.",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Dropdown(onCategoryChanged: onCategoryChanged),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (_, index) {
                          return FutureBuilder<Map<String, dynamic>>(
                            future: getUserById(
                                posts[index].fields.user.toString()),
                            builder: (context,
                                AsyncSnapshot<Map<String, dynamic>>
                                    userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                if (userSnapshot.hasError) {
                                  return Text('Error: ${userSnapshot.error}');
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      if (userSnapshot.data != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPostPage(
                                              post: posts[index],
                                              currUser: userSnapshot.data!,
                                              refreshPost: refreshPosts,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: 20.0,
                                          left: 10.0,
                                          right: 10.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                "${userSnapshot.data!["username"]}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                " · ${formatTimeDifference(posts[index].fields.dateAdded)}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (request
                                                            .jsonData["id"] ==
                                                        posts[index]
                                                            .fields
                                                            .user)
                                                      PopupMenuButton<int>(
                                                        itemBuilder:
                                                            (context) => [
                                                          PopupMenuItem(
                                                              value: 1,
                                                              child:
                                                                  Text("Edit")),
                                                          PopupMenuItem(
                                                              value: 2,
                                                              child: Text(
                                                                  "Delete")),
                                                        ],
                                                        onSelected:
                                                            (value) async {
                                                          if (value == 1) {
                                                            _title =
                                                                posts[index]
                                                                    .fields
                                                                    .title;
                                                            _text = posts[index]
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
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20)),
                                                              ),
                                                              builder:
                                                                  (context) =>
                                                                      Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height -
                                                                    100,
                                                                child: Scaffold(
                                                                  appBar:
                                                                      AppBar(
                                                                    leading:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .close),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    actions: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 10),
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                secondaryColor,
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            'Edit',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            if (_formKey.currentState!.validate()) {
                                                                              final response = await request.postJson(
                                                                                "$baseApiUrl/forum/edit-post-flutter/${posts[index].pk}/",
                                                                                jsonEncode(<String, String>{
                                                                                  'title': _title,
                                                                                  'text': _text,
                                                                                }),
                                                                              );
                                                                              if (response['status'] == 'success') {
                                                                                showCustomSnackBar(context, "Post is successfully updated");
                                                                                refreshPosts();
                                                                                Navigator.pop(context); // Menutup modal
                                                                              } else {
                                                                                showCustomSnackBar(context, "Oops, something went wrong");
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  body: Form(
                                                                    key:
                                                                        _formKey,
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                TextFormField(
                                                                                  decoration: const InputDecoration(
                                                                                    border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none,
                                                                                    ),
                                                                                    hintText: 'Type Your Title Here',
                                                                                    hintStyle: TextStyle(
                                                                                      color: primaryColor,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  initialValue: posts[index].fields.title,
                                                                                  onChanged: (String? value) {
                                                                                    setState(() {
                                                                                      _title = value!;
                                                                                    });
                                                                                  },
                                                                                  validator: (String? value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Name can't be empty!";
                                                                                    }
                                                                                    return null;
                                                                                  },
                                                                                ),
                                                                                const Divider(color: secondaryColor),
                                                                                TextFormField(
                                                                                  decoration: const InputDecoration(
                                                                                    border: UnderlineInputBorder(
                                                                                      borderSide: BorderSide.none,
                                                                                    ),
                                                                                    hintText: "What's Happening?",
                                                                                    hintStyle: TextStyle(
                                                                                      color: primaryColor,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  maxLines: 5,
                                                                                  initialValue: posts[index].fields.text,
                                                                                  onChanged: (String? value) {
                                                                                    setState(() {
                                                                                      _text = value!;
                                                                                    });
                                                                                  },
                                                                                  validator: (String? value) {
                                                                                    if (value == null || value.isEmpty) {
                                                                                      return "Content can't be empty!";
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
                                                            String id =
                                                                posts[index]
                                                                    .pk
                                                                    .toString();
                                                            final response =
                                                                await http
                                                                    .delete(
                                                              Uri.parse(
                                                                  '$baseApiUrl/forum/delete-post/$id/'),
                                                              headers: <String,
                                                                  String>{
                                                                'Content-Type':
                                                                    'application/json; charset=UTF-8',
                                                              },
                                                            );
                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              showCustomSnackBar(
                                                                  context,
                                                                  "Post is deleted successfully");
                                                              refreshPosts();
                                                            } else {
                                                              showCustomSnackBar(
                                                                  context,
                                                                  "Oops, something went wrong");
                                                            }
                                                          }
                                                        },
                                                      ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "${posts[index].fields.title}",
                                                  style: const TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "${posts[index].fields.text}",
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                if (posts[index].fields.book !=
                                                    null)
                                                  FutureBuilder<
                                                      Map<String, dynamic>>(
                                                    future: getBookById(
                                                        posts[index]
                                                            .fields
                                                            .book
                                                            .toString()),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                Map<String,
                                                                    dynamic>>
                                                            snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return CircularProgressIndicator(); // Tampilkan indikator loading saat menunggu
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}'); // Tampilkan pesan error jika terjadi kesalahan
                                                      } else {
                                                        return Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                Text(
                                                                  '${snapshot.data!["title"]}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text(
                                                                  'Author: ${snapshot.data!['authors'][0]['name']}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                              .grey[
                                                                          600]),
                                                                ),
                                                                Text(
                                                                  'Category: ${snapshot.data!['categories'][0]['name']}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                              .grey[
                                                                          600]),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20.0,
                                                      left: 10.0,
                                                      right: 10.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.mode_comment,
                                                        color: Colors.grey,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '${posts[index].commentCount}',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ))
                    ],
                  );
                }
              }
            },
          ),
        ),
        floatingActionButton: request.loggedIn == true
            ? FloatingActionButton(
                backgroundColor: secondaryColor.withOpacity(0.6),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height - 100,
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
                              padding: EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor,
                                ),
                                child: const Text(
                                  'Post',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final response = await request.postJson(
                                      "$baseApiUrl/forum/create-post-flutter/",
                                      jsonEncode(<String, String>{
                                        'title': _title,
                                        'text': _text,
                                        'book': IdBookSelected.toString(),
                                      }),
                                    );
                                    if (response['status'] == 'success') {
                                      showCustomSnackBar(context,
                                          "Post is successfully created");
                                      refreshPosts();
                                      IdBookSelected = null;
                                      Navigator.pop(context);
                                    } else {
                                      showCustomSnackBar(context,
                                          "Oops, something went wrong");
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        body: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: 'Type Your Title Here',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _title = value!;
                                          });
                                        },
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "Nama tidak boleh kosong!";
                                          }
                                          return null;
                                        },
                                      ),
                                      const Divider(color: secondaryColor),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: "What's Happening?",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        maxLines: 5,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _text = value!;
                                          });
                                        },
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "Nama tidak boleh kosong!";
                                          }
                                          return null;
                                        },
                                      ),
                                      DropdownBook(
                                        onBookSelected: (int? book) {
                                          handleBookSelected(book);
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
                },
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
