import 'package:bookbuffet/main.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:bookbuffet/pages/catalog/screens/book_detail.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';
import 'package:bookbuffet/pages/catalog/utils/user_api_service.dart';

class BookCard extends StatefulWidget {
  final Book book;
  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool? _isBookInMyBooks;

  Future<List<Rating>> getRatings() async {
    return await ApiService.getRatingsByBook(widget.book.id);
  }

  double _getMeanRating(List<Rating> ratings) {
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
    CookieRequest cookieRequest =
        Provider.of<CookieRequest>(context, listen: false);
    bool isLoggedIn = UserApiService.isLoggedin(cookieRequest);
    if (isLoggedIn) {
      UserApiService.isBookInMyBooks(cookieRequest, widget.book.id)
          .then((value) => setState(() {
                _isBookInMyBooks = value;
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rating>>(
      future: getRatings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Rating> ratings = snapshot.data!;
          double meanRating = _getMeanRating(ratings);
          return Card(
            child: InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(book: widget.book),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _isBookInMyBooks = result;
                  });
                }
              },
              onLongPress: () async {
                CookieRequest cookieRequest =
                    Provider.of<CookieRequest>(context, listen: false);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                bool isLoggedIn = UserApiService.isLoggedin(cookieRequest);
                if (isLoggedIn) {
                  _isBookInMyBooks = await UserApiService.isBookInMyBooks(
                      cookieRequest, widget.book.id);
                  if (_isBookInMyBooks!) {
                    bool isRemoved = await UserApiService.removeFromMyBooks(
                        cookieRequest, widget.book.id);
                    if (isRemoved) {
                      setState(() {
                        _isBookInMyBooks = false;
                      });
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Book removed from My Books'),
                        ),
                      );
                    } else {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Failed to remove book from My Books'),
                        ),
                      );
                    }
                  } else {
                    bool isAdded = await UserApiService.addToMyBooks(
                        cookieRequest, widget.book.id);
                    if (isAdded) {
                      setState(() {
                        _isBookInMyBooks = true;
                      });
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Book added to My Books'),
                        ),
                      );
                    } else {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Failed to add book to My Books'),
                        ),
                      );
                    }
                  }
                } else {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Please login to add books to My Books'),
                    ),
                  );
                }
              },
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Add a book cover image
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: widget.book.cover,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      // Add a book title
                      Text(
                        widget.book.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway',
                        ),
                      ),
                      // Add a book authors
                      // If there are more than one author,
                      // just show the first one
                      // followed by 'et al.'
                      Text(
                        widget.book.authors.length > 1
                            ? '${widget.book.authors[0].name} et al.'
                            : widget.book.authors[0].name,
                        textAlign: TextAlign.center,
                      ),
                      // Add a mean rating
                      // If there are no ratings, show '0 ⭐ (0)'
                      // If there are ratings, show the mean rating
                      // followed by the number of ratings in brackets
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ratings.isEmpty
                                ? '0'
                                : meanRating.toStringAsFixed(1),
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(
                            ' (${ratings.length})',
                          )
                        ],
                      ),
                    ],
                  ),
                  // Add a bookmarket icon to show
                  // if the book is in My Books
                  // or not
                  // And position it to the top right corner
                  // of the card
                  // Only show the icon
                  // Don't make it clickable
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Consumer<CookieRequest>(
                      builder: (context, cookieRequest, child) {
                        bool isLoggedIn =
                            UserApiService.isLoggedin(cookieRequest);
                        if (isLoggedIn) {
                          return Icon(
                            _isBookInMyBooks!
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: secondaryColor,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
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
    );
  }
}
