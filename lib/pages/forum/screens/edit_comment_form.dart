// EditCommentForm.dart
import 'package:bookbuffet/pages/forum/models/comment.dart';
import 'package:flutter/material.dart';

class EditCommentForm extends StatefulWidget {
  final Comment comment;
  final VoidCallback onCommentEdited;

  EditCommentForm(
      {Key? key, required this.comment, required this.onCommentEdited})
      : super(key: key);

  @override
  _EditCommentFormState createState() => _EditCommentFormState();
}

class _EditCommentFormState extends State<EditCommentForm> {
  final _formKey = GlobalKey<FormState>();
  String _text = "";

  @override
  void initState() {
    super.initState();
    _text = widget.comment.fields.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                        borderSide: BorderSide.none, // hilangkan border
                      ),
                      hintText: "What's your thoughts?",
                      hintStyle: TextStyle(
                        color: Colors
                            .grey, // ganti dengan warna yang Anda inginkan
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxLines: 5,
                    initialValue: widget.comment.fields.text,
                    onChanged: (String? value) {
                      setState(() {
                        _text = value!;
                      });
                    },
                    validator: (String? value) {
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
    );
  }
}
