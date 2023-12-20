import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';
import 'package:bookbuffet/pages/catalog/widgets/search_book_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  Future<List<Book>>? _searchResults;

  void _searchBooks(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = ApiService.searchBooks(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search books',
            ),
            onSubmitted: (value) {
              _searchBooks(value);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<Book>>(
            future: _searchResults,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<Book> books = snapshot.data!;
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return SearchBookCard(book: books[index]);
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                if (_searchController.text.isNotEmpty) {
                  return const Center(
                    child: Text("No results found"),
                  );
                }
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text("Search for books"),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
//       body: FutureBuilder<List<Book>>(
//         future: _searchResults,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             List<Book> books = snapshot.data!;
//             return ListView.builder(
//               itemCount: books.length,
//               itemBuilder: (context, index) {
//                 return BookCard(book: books[index]);
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("${snapshot.error}"),
//             );
//           } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//             if (_searchController.text.isNotEmpty) {
//               return const Center(
//                 child: Text("No results found"),
//               );
//             }
//           } else if (!snapshot.hasData) {
//             return const Center(
//               child: Text("Search for books"),
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }
