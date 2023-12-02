import 'package:bookbuffet/controller/bottom_bar.dart';
import 'package:bookbuffet/pages/base.dart';
import 'package:bookbuffet/pages/forum/models/post.dart';
import 'package:bookbuffet/pages/forum/screens/detail_post.dart';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/widgets/bottom_bar.dart';
import 'package:bookbuffet/widgets/left-drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void refreshPosts() {
    setState(() {});
  }

  Future<List<Post>> fetchPost() async {
    var url = Uri.parse('http://127.0.0.1:8000/forum/post/json/');
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Post> list_post = [];
    for (var d in data) {
      if (d != null) {
        list_post.add(Post.fromJson(d));
      }
    }
    return list_post;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    BottomBarController controller = Get.find<BottomBarController>();
    return Scaffold(
      body: FutureBuilder<List<Post>>(
        future: fetchPost(),
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: getUserById(
                        snapshot.data![index].fields.user.toString()),
                    builder: (context,
                        AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
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
                                    builder: (context) => DetailPostPage(
                                      post: snapshot.data![index],
                                      currUser: userSnapshot.data!,
                                      refreshPost: refreshPosts,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${userSnapshot.data!["username"]}",
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            if (userSnapshot.data!["id"] ==
                                                snapshot
                                                    .data![index].fields.user)
                                              PopupMenuButton<int>(
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      value: 1,
                                                      child: Text("Edit")),
                                                  PopupMenuItem(
                                                      value: 2,
                                                      child: Text("Delete")),
                                                ],
                                                onSelected: (value) async {
                                                  if (value == 1) {
                                                    _title = snapshot
                                                        .data![index]
                                                        .fields
                                                        .title;
                                                    _text = snapshot
                                                        .data![index]
                                                        .fields
                                                        .text;
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape: Border.all(),
                                                      builder: (context) =>
                                                          Container(
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .height,
                                                        child: Scaffold(
                                                          appBar: AppBar(
                                                            leading: IconButton(
                                                              icon: const Icon(
                                                                  Icons.close),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            actions: [
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
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    final response =
                                                                        await request
                                                                            .postJson(
                                                                      "http://127.0.0.1:8000/forum/edit-post-flutter/${snapshot.data![index].pk}/",
                                                                      jsonEncode(<String,
                                                                          String>{
                                                                        'title':
                                                                            _title,
                                                                        'text':
                                                                            _text,
                                                                      }),
                                                                    );
                                                                    if (response[
                                                                            'status'] ==
                                                                        'success') {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text("Post berhasil diperbarui!"),
                                                                        ),
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        fetchPost(); // Memanggil fetchPost lagi untuk memperbarui daftar post
                                                                      });
                                                                      Navigator.pop(
                                                                          context); // Menutup modal
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text("Terdapat kesalahan, silakan coba lagi."),
                                                                        ),
                                                                      );
                                                                    }
                                                                  }
                                                                },
                                                              ),
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
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        TextFormField(
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide.none, // hilangkan border
                                                                            ),
                                                                            hintText:
                                                                                'Type Your Title Here',
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey, // ganti dengan warna yang Anda inginkan
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          initialValue: snapshot
                                                                              .data![index]
                                                                              .fields
                                                                              .title,
                                                                          onChanged:
                                                                              (String? value) {
                                                                            setState(() {
                                                                              _title = value!;
                                                                            });
                                                                          },
                                                                          validator:
                                                                              (String? value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
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
                                                                              borderSide: BorderSide.none, // hilangkan border
                                                                            ),
                                                                            hintText:
                                                                                "What's Happening?",
                                                                            hintStyle:
                                                                                TextStyle(
                                                                              color: Colors.grey, // ganti dengan warna yang Anda inginkan
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          maxLines:
                                                                              5,
                                                                          initialValue: snapshot
                                                                              .data![index]
                                                                              .fields
                                                                              .text,
                                                                          onChanged:
                                                                              (String? value) {
                                                                            setState(() {
                                                                              _text = value!;
                                                                            });
                                                                          },
                                                                          validator:
                                                                              (String? value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
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
                                                    String id = snapshot
                                                        .data![index].pk
                                                        .toString();
                                                    final response =
                                                        await http.delete(
                                                      Uri.parse(
                                                          'http://127.0.0.1:8000/forum/delete-post/$id/'),
                                                      headers: <String, String>{
                                                        'Content-Type':
                                                            'application/json; charset=UTF-8',
                                                      },
                                                    );
                                                    if (response.statusCode ==
                                                        200) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            "Post baru berhasil dihapus!"),
                                                      ));
                                                      setState(() {
                                                        fetchPost(); // Memanggil fetchPost lagi untuk memperbarui daftar post
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            "Terdapat kesalahan, silakan coba lagi."),
                                                      ));
                                                    }
                                                  }
                                                },
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${snapshot.data![index].fields.title}",
                                          style: const TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${snapshot.data![index].fields.text}",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
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
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: Border.all(),
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    ElevatedButton(
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
                              "http://127.0.0.1:8000/forum/create-post-flutter/",
                              jsonEncode(<String, String>{
                                'title': _title,
                                'text': _text,
                              }));
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Produk baru berhasil disimpan!"),
                            ));
                            setState(() {
                              fetchPost(); // Memanggil fetchPost lagi untuk memperbarui daftar post
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Terdapat kesalahan, silakan coba lagi."),
                            ));
                          }
                        }
                      },
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
                                      borderSide:
                                          BorderSide.none, // hilangkan border
                                    ),
                                    hintText: 'Type Your Title Here',
                                    hintStyle: TextStyle(
                                      color: Colors
                                          .grey, // ganti dengan warna yang Anda inginkan
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

                                const Divider(
                                    color:
                                        secondaryColor), // tambahkan garis pembatas
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide.none, // hilangkan border
                                    ),
                                    hintText: "What's Happening?",
                                    hintStyle: TextStyle(
                                      color: Colors
                                          .grey, // ganti dengan warna yang Anda inginkan
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
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
