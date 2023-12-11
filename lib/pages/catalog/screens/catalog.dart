import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/category.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';
import 'package:bookbuffet/pages/catalog/widgets/book_card.dart';

class Catalog extends StatefulWidget {
  const Catalog({Key? key}) : super(key: key);

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  late Future<List<Book>> _books;
  late Future<List<Category>> _categories;
  int _length = 0;

  @override
  void initState() {
    super.initState();
    _books = ApiService.getBooks();
    _categories = ApiService.getCategories();
    // Get the number of categories
    // to generate the tabs
    _categories.then((value) => _length = value.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Category>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> categories = snapshot.data!;
            return DefaultTabController(
              // Add tabs as per the number of categories
              // calculated from the API
              length: _length + 1,
              child: Scaffold(
                appBar: AppBar(
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
                      onPressed: () {},
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
                          return ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (context, index) {
                              return BookCard(book: books[index]);
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
                        future: ApiService.getBooksByCategory(index + 1),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Book> books = snapshot.data!;
                            return ListView.builder(
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                return BookCard(book: books[index]);
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
//       child: DefaultTabController(
//         // Add tabs as per the number of categories
//         // calculated from the API
//         length: _length,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Book Buffet'),
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(50),
//               child: FutureBuilder<List<Category>>(
//                 future: _categories,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     List<Category> categories = snapshot.data!;
//                     return TabBar(isScrollable: true, tabs: [
//                       const Tab(
//                         text: 'All',
//                       ),
//                       // Add a tab for each category
//                       // from the API
//                       ...categories.map((Category category) {
//                         return Tab(
//                           text: category.name,
//                         );
//                       }).toList(),
//                     ]);
//                   } else if (snapshot.hasError) {
//                     return const Center(
//                       child: Text('Something went wrong!'),
//                     );
//                   }
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//             ),
//             actions: [
//               // Add a my books button to the app bar
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.book),
//               ),
//               // Add a search button to the app bar
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(Icons.search),
//               ),
//             ],
//           ),
//           body: TabBarView(
//             // Add a list view for each tab
//             // Based on its category
//             // First tab for all books
//             children: [
//               FutureBuilder<List<Book>>(
//                 future: _books,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     List<Book> books = snapshot.data!;
//                     return ListView.builder(
//                       itemCount: books.length,
//                       itemBuilder: (context, index) {
//                         return BookCard(book: books[index]);
//                       },
//                     );
//                   } else if (snapshot.hasError) {
//                     return const Center(
//                       child: Text('Something went wrong!'),
//                     );
//                   }
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 },
//               ),
//               // Add a tab for each category
//               // from the API
//               ...List.generate(_length, (index) {
//                 return FutureBuilder<List<Book>>(
//                   future: ApiService.getBooksByCategory(index + 1),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       List<Book> books = snapshot.data!;
//                       return ListView.builder(
//                         itemCount: books.length,
//                         itemBuilder: (context, index) {
//                           return BookCard(book: books[index]);
//                         },
//                       );
//                     } else if (snapshot.hasError) {
//                       return const Center(
//                         child: Text('Something went wrong!'),
//                       );
//                     }
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   },
//                 );
//               }).toList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
