import 'dart:async';
import 'dart:convert';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/forum/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CommentForm extends StatefulWidget {
  final String postId;
  final Function(String) onCommentChanged;
  final FocusNode focusNode;
  final StreamController<void> refreshController;

  CommentForm({
    required this.postId,
    required this.onCommentChanged,
    required this.focusNode,
    required this.refreshController,
  });

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: secondaryColor),
              borderRadius: BorderRadius.circular(10.0),
              color: primaryColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    focusNode: widget.focusNode,
                    decoration: InputDecoration(
                      hintText: "Post your comment",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        widget.onCommentChanged(value!);
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Comment tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(10.0),
                    ),
                    onPressed: _commentController.text.isEmpty
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/forum/create-comment-flutter/",
                                jsonEncode(<String, String>{
                                  'text': _commentController.text,
                                  'post_id': widget.postId,
                                }),
                              );
                              if (response['status'] == 'success') {
                                showCustomSnackBar(
                                    context, "Comment created successfully");
                                _commentController.text = "";
                                widget.refreshController
                                    .add(null); // Refresh the comments
                              } else {
                                showCustomSnackBar(
                                    context, "Oops, something went wrong");
                              }
                            }
                          },
                    child: const Text(
                      "Comment",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
