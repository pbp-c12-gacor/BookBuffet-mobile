import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:bookbuffet/pages/catalog/widgets/books_by_author.dart';
import 'package:bookbuffet/pages/catalog/widgets/ratings.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';

class BookDetail extends StatefulWidget {
  final Book book;
  const BookDetail({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  // Add a list of book ratings
  late Future<List<Rating>> _ratings;
  // Add a list of book by the same authors
  late List<Future<List<Book>>> _booksByAuthors = [];

  double _getMeanRating(Future<List<Rating>> ratings) {
    double meanRating = 0;
    ratings.then((value) {
      for (var rating in value) {
        meanRating += rating.rating;
      }
      meanRating = meanRating / value.length;
    });
    return meanRating;
  }

  @override
  void initState() {
    super.initState();
    _ratings = ApiService.getRatingsByBook(widget.book.id);
    for (var author in widget.book.authors) {
      _booksByAuthors.add(ApiService.getBooksByAuthor(author.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // Add a back button to the app bar
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(widget.book.title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 128,
                  child: CachedNetworkImage(
                    imageUrl: widget.book.cover,
                    width: double.infinity,
                    height: 250,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width - 128 - 32,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.book.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.book.subtitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'by ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    // show all authors separated by a comma
                                    TextSpan(
                                      text: widget.book.authors
                                          .map((author) => author.name)
                                          .join(', '),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text(
                                    _getMeanRating(_ratings).toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  FutureBuilder<List<Rating>>(
                                    future: _ratings,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Rating> ratings = snapshot.data!;
                                        return Text(
                                          ratings.isEmpty
                                              ? ' (0)'
                                              : ' (${ratings.length})',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.book.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Published by ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.book.publisher != ""
                                        ? widget.book.publisher
                                        : "Unknown",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Text(
                                    ' on ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.book.publishedDate.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Language: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.book.language
                                        .toString()
                                        .split('.')[1],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'ISBN-10: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.book.isbn10,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'ISBN-13: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.book.isbn13,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Pages: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.book.pageCount.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Categories: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.book.categories
                                        .map((category) => category.name)
                                        .join(', '),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              // Row(
                              //   children: [
                              //     const Text(
                              //       'Preview: ',
                              //       style: TextStyle(
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //     Text(
                              //       widget.book.previewLink,
                              //       style: const TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 16,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(
                              //   height: 8,
                              // ),
                            ]))),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add a header for ratings
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ratings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                // Add a list of ratings
                Ratings(ratings: _ratings),
                // Add a header for books by the same authors
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Books by the same authors',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                // Add a list of books by the same authors
                BooksByAuthor(
                  booksByAuthors: _booksByAuthors,
                  authors: widget.book.authors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
