// import 'package:bookbuffet/main.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';

// import 'package:bookbuffet/widgets/left-drawer.dart';
// import 'package:bookbuffet/pages/MyBooks/models/MyBook.dart';

// class MyBooksPage extends StatefulWidget {
//   const MyBooksPage({super.key});

//   @override
//   BookPageState createState() => BookPageState()
// }

// class BookPageState extends State<MyBooksPage> {

//   @override
//   Widget build(BuildContext context) {

//     final request = context.watch<CookieRequest>();
//       Future<List<MyBook>> response = request
//         .postJson("http://127.0.0.1:8000/get-my-books/",
//             jsonEncode(<String, String>{"Content-Type": "application/json"}))
//         .then((value) {
//       if (value == null) {
//         return [];
//       }
//       var jsonValue = jsonDecode(value);
//       List<MyBook> listMyBook = [];
//       for (var data in jsonValue) {
//         if (data != null) {
//           listMyBook.add(MyBook.fromJson(data));
//         }
//       }
//       return listMyBook;
//     });
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('MyBook'),
//         ),
//         drawer: const LeftDrawer(),
//         body: FutureBuilder(
//             future: response,
//             builder: (context, AsyncSnapshot snapshot) {
//               if (!snapshot.hasData) {
//                 return const Column(
//                   children: [
//                     Text(
//                       "No Books have been added.",
//                       style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
//                     ),
//                     SizedBox(height: 8),
//                   ],
//                 );
//               } else {
//                 return ListView.builder(
//                   MyBookCount: snapshot.data!.length,
//                   MyBookBuilder: (_, index) => InkWell(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => MyBookDetailPage(
//                                     MyBook: snapshot.data![index],
//                                   )));
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${snapshot.data![index].fields.title}",
//                             style: const TextStyle(
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           // const SizedBox(height: 10),
//                           // Text("${snapshot.data![index].fields.price}"),
//                           // const SizedBox(height: 10),
//                           // Text("${snapshot.data![index].fields.amount}"),
//                           const SizedBox(height: 10),
//                           Text("${snapshot.data![index].fields.description}"),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             }));

// }
// }

import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:bookbuffet/widgets/left-drawer.dart';
import 'package:bookbuffet/pages/MyBooks/models/MyBook.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({Key? key}) : super(key: key);

  @override
  BookPageState createState() => BookPageState();
}

class BookPageState extends State<MyBooksPage> {
  Future<List<MyBook>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    print("uigy");
    var url = Uri.parse('http://127.0.0.1:8000/MyBooks/get-mybooks/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    // print(response.body);

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(response.body);
    // melakukan konversi data json menjadi object Product
    List<MyBook> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(MyBook.fromJson(d));
      }
    }

    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // Future<List<MyBook>> response = request
    //     .postJson("http://127.0.0.1:8000/MyBooks/get-mybooks/",
    //         jsonEncode(<String, String>{"Content-Type": "application/json"}))
    //     .then((value) {
    //   if (value == null) {
    //     return [];
    //   }
    //   print(response.body);
    //   var jsonValue = jsonDecode(value);
    //   List<MyBook> listMyBook = [];
    //   for (var data in jsonValue) {
    //     if (data != null) {
    //       listMyBook.add(MyBook.fromJson(data));
    //     }
    //   }
    //   return listMyBook;
    // });

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Books'),
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder<List<MyBook>>(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot<List<MyBook>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No Books have been added.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => MyBookDetailPage(
                    //         book: snapshot.data![index],
                    //       ),
                    //     ),
                    //   );
                    // },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.data![index].fields.title}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("${snapshot.data![index].fields.description}"),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
