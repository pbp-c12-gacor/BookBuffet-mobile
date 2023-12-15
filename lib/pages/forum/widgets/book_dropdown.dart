import 'dart:convert';

import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownBook extends StatefulWidget {
  final ValueChanged<String?>? onBookChanged;
  final VoidCallback? onCancel;
  final ValueChanged<int?>? onBookSelected;

  const DropdownBook({this.onBookChanged, this.onCancel, this.onBookSelected});

  @override
  _ModalBookState createState() => _ModalBookState();
}

class _ModalBookState extends State<DropdownBook> {
  List<dynamic> books = [];
  String? selectedBook;
  String? dropdownValue;
  String baseApiUrl = 'https://bookbuffet.onrender.com';

  Future<List<dynamic>> getBooks() async {
    var url = Uri.parse('$baseApiUrl/api/books/');
    var response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getBooks(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                      hint: Text("Select Book"),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                        if (widget.onBookChanged != null) {
                          widget.onBookChanged!(dropdownValue);
                        }
                      },
                      items: snapshot.data!
                          .map<DropdownMenuItem<String>>((dynamic book) {
                        return DropdownMenuItem<String>(
                          value: book['title'],
                          child: Text(book['title']),
                          onTap: () {
                            if (widget.onBookSelected != null) {
                              widget.onBookSelected!(book["id"]);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  if (dropdownValue != null)
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            dropdownValue = null;
                            widget.onBookSelected!(null);
                          });
                        },
                      ),
                    ),
                ],
              ));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
