import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/category.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';
import 'package:bookbuffet/pages/catalog/widgets/book_card.dart';
import 'package:bookbuffet/pages/MyBooks/screens/mybooks.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  late Future<List<Book>> _books = ApiService.getBooks();
  late Future<List<Category>> _categories = ApiService.getCategories();
  late Future<List<Future<List<Book>>>> _booksByCategory = Future.value([]);
  int _length = 0;

  @override
  void initState() {
    super.initState();
    loadData();
    checkForNewBooks();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    if (prefs.getString('books') != null) {
      _books = Future.value(List<Book>.from(
          jsonDecode(prefs.getString('books')!).map((x) => Book.fromJson(x))));
    }
    if (prefs.getString('categories') != null) {
      _categories = Future.value(List<Category>.from(
          jsonDecode(prefs.getString('categories')!)
              .map((x) => Category.fromJson(x))));
    }
    if (prefs.getString('booksByCategory') != null) {
      _booksByCategory = Future.value(List<Future<List<Book>>>.from(
          jsonDecode(prefs.getString('booksByCategory')!).map((x) =>
              Future.value(List<Book>.from(x.map((x) => Book.fromJson(x)))))));
    } else {
      // Add a list for each category
      // from the API
      _categories.then((value) {
        _booksByCategory = Future.value(List.generate(value.length, (index) {
          return ApiService.getBooksByCategory(index + 1);
        }));
      });
      // Save the list of lists to shared preferences
      Future.delayed(const Duration(seconds: 5), () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<Future<List<Book>>> booksByCategoryFuture = await _booksByCategory;
        List<List<Book>> booksByCategory =
            await Future.wait(booksByCategoryFuture);
        String booksByCategoryJson = jsonEncode(booksByCategory);
        prefs.setString('booksByCategory', booksByCategoryJson);
      });
    }
    _categories.then((value) => _length = value.length);
  }

  void saveCategories(List<Category> categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('categories', jsonEncode(categories));
  }

  void saveBooks(List<Book> books) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('books', jsonEncode(books));
  }

  void checkForNewBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Book> currentBooks = [];
    if (prefs.getString('books') != null) {
      currentBooks = List<Book>.from(
          jsonDecode(prefs.getString('books')!).map((x) => Book.fromJson(x)));
    } else {
      return;
    }
    int lastBookId = currentBooks.last.id;
    bool newBooks = true;

    while (newBooks) {
      lastBookId++;
      try {
        Book book = await ApiService.getBook(lastBookId);
        setState(() {
          _books.then((value) => value.add(book));
          for (var category in book.categories) {
            _booksByCategory.then((value) {
              value[category.id - 1].then((value) => value.add(book));
            });
          }
        });
      } catch (e) {
        newBooks = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Category>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> categories = snapshot.data!;
            saveCategories(categories);
            return DefaultTabController(
              // Add tabs as per the number of categories
              // calculated from the API
              length: _length + 1,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Book Buffet'),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: TabBar(isScrollable: true, tabs: [
                      const Tab(
                        text: 'All',
                      ),
                      // Add a tab for each category
                      // from the API
                      ...categories.map((Category category) {
                        return Tab(
                          text: category.name,
                        );
                      }).toList(),
                    ]),
                  ),
                  actions: [
                    // Add a my books button to the app bar
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyBooksPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.book),
                    ),
                    // Add a search button to the app bar
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                body: TabBarView(
                  // Add a list view for each tab
                  // Based on its category
                  // First tab for all books
                  children: [
                    FutureBuilder<List<Book>>(
                      future: _books,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Book> books = snapshot.data!;
                          saveBooks(books);
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BookCard(book: books[index]),
                              );
                            },
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
                    ),
                    // Add a tab for each category
                    // from the API
                    ...List.generate(_length, (index) {
                      return FutureBuilder<List<Book>>(
                        future: _booksByCategory.then((value) => value[index]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Book> books = snapshot.data!;
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BookCard(book: books[index]),
                                );
                              },
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
                      );
                    }).toList(),
                  ],
                ),
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
      ),
    );
  }
}
