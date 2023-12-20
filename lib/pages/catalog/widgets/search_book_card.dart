import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:bookbuffet/pages/catalog/screens/book_detail.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';

class SearchBookCard extends StatefulWidget {
  final Book book;
  const SearchBookCard({Key? key, required this.book}) : super(key: key);

  @override
  _SearchBookCardState createState() => _SearchBookCardState();
}

class _SearchBookCardState extends State<SearchBookCard> {
  Future<List<Rating>> getRatings() async {
    return await ApiService.getRatingsByBook(widget.book.id);
  }

  double _getMeanRating(List<Rating> ratings) {
    if (ratings.isEmpty) {
      return 0;
    }
    double meanRating = 0;
    for (var rating in ratings) {
      meanRating += rating.rating;
    }
    meanRating = meanRating / ratings.length;
    return meanRating;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rating>>(
      future: getRatings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Rating> ratings = snapshot.data!;
          double meanRating = _getMeanRating(ratings);
          return GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetail(book: widget.book),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: widget.book.id,
                        child: CachedNetworkImage(
                          imageUrl: widget.book.cover,
                          height: 150,
                        ),
                      ),
                      Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Add title, author, year if it exists
                                  Text(
                                    widget.book.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    widget.book.authors.length > 1
                                        ? '${widget.book.authors[0].name} et al.'
                                        : widget.book.authors[0].name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ))),
                      const Divider(),
                      // Show the mean rating with big stars
                      // followed by the number of ratings in brackets
                      Column(
                        children: [
                          RatingBarIndicator(
                            rating: meanRating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 16,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${meanRating.toStringAsFixed(1)}/5.0',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '(${ratings.length})',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
