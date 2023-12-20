import 'package:bookbuffet/controller/bottom_bar.dart';
import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bookbuffet/pages/base.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController authorsController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController publishedDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pageCountController = TextEditingController();
  TextEditingController categoriesController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController previewLinkController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController isbn10Controller = TextEditingController();
  TextEditingController isbn13Controller = TextEditingController();

  XFile? selectedImage;
  String? base64Image;
  String baseApiUrl = 'https://bookbuffet.onrender.com';

  Future<void> uploadImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      base64Image = base64Encode(imageBytes);

      setState(() {
        selectedImage = pickedFile;
        coverController.text = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    BottomBarController controller = Get.put(BottomBarController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Publish Your Book Here!",
            ),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Type your book title here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: subtitleController,
                    decoration: const InputDecoration(
                      labelText: 'Subtitle',
                      hintText: 'Type your book subtitle here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the subtitle';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: authorsController,
                    decoration: const InputDecoration(
                      labelText: 'Authors',
                      hintText: 'Seperate each Authors with Comma (,)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the authors';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: publisherController,
                    decoration: const InputDecoration(
                      labelText: 'Publisher',
                      hintText: 'Type your book publisher here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the publisher';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: publishedDateController,
                    decoration: const InputDecoration(
                      labelText: 'Published Date',
                      hintText: 'Enter the year number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the published date';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter with digits';
                      }
                      if (int.parse(value) <= 0) {
                        return 'Please enter a valid published date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Type your book description here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: pageCountController,
                    decoration: const InputDecoration(
                      labelText: 'Page Count',
                      hintText: 'Type your book page count here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the page count';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter with digits';
                      }
                      if (int.parse(value) <= 0) {
                        return 'Please enter a valid page count';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: categoriesController,
                    decoration: const InputDecoration(
                      labelText: 'Categories',
                      hintText: 'Separate each categories with Comma (,)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the categories';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: languageController,
                    decoration: const InputDecoration(
                      labelText: 'Language',
                      hintText: 'Type your book language here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the categories';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: previewLinkController,
                    decoration: const InputDecoration(
                      labelText: 'Preview Link',
                      hintText: 'Type your book preview link here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the preview link';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          await uploadImage();
                        },
                        controller: coverController,
                        decoration: const InputDecoration(
                          labelText: 'Cover',
                          hintText: 'Upload your book cover here',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (selectedImage == null) {
                            return 'Please pick an image';
                          }
                          return null;
                        },
                      ),
                      if (selectedImage != null)
                        Positioned(
                          right: 8.0,
                          top: 5.0,
                          bottom: 5.0,
                          child: Image.network(
                            selectedImage!.path,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: isbn10Controller,
                    decoration: const InputDecoration(
                      labelText: 'ISBN 10',
                      hintText: 'Type your book ISBN 10 here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the ISBN 10';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: isbn13Controller,
                    decoration: const InputDecoration(
                      labelText: 'ISBN 13',
                      hintText: 'Type your book ISBN 13 here',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the ISBN 13';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String fileName = selectedImage!.name.split('/').last;

                        final response = await request.postJson(
                          "$baseApiUrl/publish/create-publish-flutter/",
                          jsonEncode(
                            <String, dynamic>{
                              'title': titleController.text,
                              'subtitle': subtitleController.text,
                              'authors': authorsController.text,
                              'publisher': publisherController.text,
                              'published_date':
                                  int.parse(publishedDateController.text),
                              'description': descriptionController.text,
                              'page_count': int.parse(pageCountController.text),
                              'categories': categoriesController.text,
                              'language': languageController.text,
                              'preview_link': previewLinkController.text,
                              'cover': {
                                'file': base64Image,
                                'name': fileName,
                              },
                              'isbn_10': isbn10Controller.text,
                              'isbn_13': isbn13Controller.text,
                            },
                          ),
                        );

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Your book has been published! Please wait for forward confirmation.",
                              ),
                            ),
                          );
                          controller.index.value = 0;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BasePage(
                                initialIndex: 0,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Oops, something went wrong"),
                            ),
                          );
                        }

                        _formKey.currentState!.reset();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 20,
                      ),
                    ),
                    child: const Text(
                      'Click Here to Publish!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
