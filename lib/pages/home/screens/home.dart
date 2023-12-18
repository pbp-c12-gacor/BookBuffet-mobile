import 'package:bookbuffet/controller/bottom_bar.dart';
import 'package:bookbuffet/main.dart';
import 'package:bookbuffet/pages/base.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:bookbuffet/pages/catalog/screens/book_detail.dart';
import 'package:bookbuffet/pages/catalog/screens/catalog.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';
import 'package:bookbuffet/pages/catalog/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  static String baseApiUrl = 'https://bookbuffet.onrender.com/api';
  late Future<List<Book>> _books;
  late Future<List<Book>> _booksSorted;

  static Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse('$baseApiUrl/books/'));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      if (books.length > 8) {
        books = books.take(8).toList();
      }
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<List<Book>> getBooksSorted() async {
    final response = await http.get(Uri.parse('$baseApiUrl/books/'));
    if (response.statusCode == 200) {
      List<Book> books = bookFromJson(response.body);
      Map<Book, double> bookRatings = {};
      for (var book in books) {
        List<Rating> ratings = await ApiService.getRatingsByBook(book.id);
        double meanRating = _getMeanRating(ratings);
        bookRatings[book] = meanRating;
      }
      books.sort((a, b) => bookRatings[b]!.compareTo(bookRatings[a]!));
      books = books.take(8).toList();
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }

  static double _getMeanRating(List<Rating> ratings) {
    double meanRating = 0;
    for (var rating in ratings) {
      meanRating += rating.rating;
    }
    meanRating = meanRating / ratings.length;
    return meanRating;
  }

  @override
  void initState() {
    super.initState();
    _books = getBooks();
    _booksSorted = getBooksSorted();
  }

  BottomBarController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String greeting = "Halo";
    String username = "User";
    String initial = "U";
    int _length = 0;

    if (request.loggedIn && request.jsonData.isNotEmpty) {
      username = request.jsonData["username"] ?? "User";
      initial = username.isNotEmpty ? username[0].toUpperCase() : "U";
      greeting += ', ${username}';
    }

    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${greeting}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: secondaryColor,
                        child: Text(
                          initial,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ourBooks(),
                  SizedBox(
                    height: 30,
                  ),
                  getSectionQuoate(),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  readerToday(),
                  SizedBox(
                    height: 30,
                  ),
                  // specialForYou(),
                  // SizedBox(
                  //   height: 30,
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSectionQuoate() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quote of the Day",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "I'd rather have roses on my table than diamonds on my neck.",
              style: TextStyle(
                  fontSize: 15, height: 1.5, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Emma Goldman",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget readerToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reader today",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1544716278-e513176f20b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fGJvb2t8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60"),
                  fit: BoxFit.cover)),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget specialForYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Special for you",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 3,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
        ),
        FutureBuilder<List<Book>>(
          future: _booksSorted,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Book> books = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: books.map((book) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetail(book: book),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Image.network(book
                                    .cover), // asumsikan setiap buku memiliki cover
                                Text(book
                                    .title), // asumsikan setiap buku memiliki title
                                // tambahkan lebih banyak detail buku di sini jika diperlukan
                              ],
                            ),
                          ),
                        ));
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }

  Widget ourBooks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Some Of Our Books",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 3,
                ),
                IconButton(
                  onPressed: () {
                    BottomBarController controller = Get.find();
                    controller.index.value = 1;
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 14,
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
        ),
        FutureBuilder<List<Book>>(
          future: _books,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Book> books = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: books.map((book) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetail(book: book),
                              ),
                            );
                          },
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/bg.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              height: 250, // Tinggi kartu
                              width: 200, // Lebar kartu
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Pusatkan konten kolom
                                children: <Widget>[
                                  Center(
                                    // Pusatkan gambar
                                    child: Image.network(
                                      book.cover,
                                      fit: BoxFit
                                          .cover, // Gambar akan menyesuaikan ukuran container
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      book.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow
                                          .ellipsis, // Tambahkan ini
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    );
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
      ],
    );
  }
}
