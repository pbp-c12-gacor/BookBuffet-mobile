import 'dart:convert';
import 'package:bookbuffet/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final ValueChanged<String?>? onCategoryChanged;

  const Dropdown({this.onCategoryChanged});

  @override
  _DropdownState createState() => _DropdownState();
}

Future<List<String>> getCategories() async {
  var url = Uri.parse('http://127.0.0.1:8000/api/categories/');
  var response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
    },
  );
  var data = jsonDecode(utf8.decode(response.bodyBytes));
  if (response.statusCode == 200) {
    List<String> list_categories = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] != null) {
        list_categories.add(data[i]["name"]);
      }
    }
    return list_categories;
  } else {
    throw Exception('Failed to load user');
  }
}

class _DropdownState extends State<Dropdown> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
                    hint: Text("Categories"),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        widget.onCategoryChanged!(dropdownValue);
                      });
                    },
                    items: snapshot.data!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                if (dropdownValue != null)
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          dropdownValue = null;
                          widget.onCategoryChanged!(null);
                        });
                      },
                    ),
                  ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
