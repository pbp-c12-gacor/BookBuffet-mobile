import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/author.dart';
import 'package:bookbuffet/pages/catalog/widgets/book_card.dart';

class BooksByAuthor extends StatelessWidget {
  final List<Future<List<Book>>> booksByAuthors;
  final List<Author> authors;
  const BooksByAuthor(
      {Key? key, required this.booksByAuthors, required this.authors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Make a listview of book cards
    // for each author
    return SizedBox(
        height: 250 * booksByAuthors.length.toDouble(),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: booksByAuthors.length,
          itemBuilder: (context, index) {
            return FutureBuilder<List<Book>>(
              future: booksByAuthors[index],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Book> books = snapshot.data!;
                  return Column(
                    children: [
                      // Add a header for each author
                      Text(
                        "Books by ${authors[index].name}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Add a book card for each book
                      // by the author
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 150,
                                child: BookCard(book: books[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
          },
        ));
  }
}
