import 'dart:async';
import 'dart:convert';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PublishForm extends StatefulWidget {
  const PublishForm({super.key});

  @override
  _PublishFormState createState() => _PublishFormState();
}

class _PublishFormState extends State<PublishForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
