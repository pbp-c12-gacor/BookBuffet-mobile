import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookbuffet/pages/catalog/models/book.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:bookbuffet/pages/catalog/screens/book_detail.dart';
import 'package:bookbuffet/pages/catalog/utils/api_service.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({Key? key, required this.book}) : super(key: key);

  Future<List<Rating>> getRatings() async {
    return await ApiService.getRatingsByBook(book.id);
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
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rating>>(
      future: getRatings(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Rating> ratings = snapshot.data!;
          double meanRating = _getMeanRating(ratings);
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetail(book: book),
                  ),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add to my books'),
                      content: const Text('Do you want to add this book?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add a book cover image
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: book.cover,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  // Add a book title
                  Text(
                    book.title,
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
                    book.authors.length > 1
                        ? '${book.authors[0].name} et al.'
                        : book.authors[0].name,
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
                        ratings.isEmpty ? '0' : meanRating.toStringAsFixed(1),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Text(
                        ' (${ratings.length})',
                      )
                    ],
                  )
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
//     return Card(
//       child: InkWell(
//         onTap: () {},
//         onLongPress: () {},
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Add a book cover image
//             CachedNetworkImage(
//               imageUrl: baseImageUrl + book.cover,
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//             // Add a book title
//             Text(
//               book.title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             // Add a book authors
//             // If there are more than one author,
//             // just show the first one
//             // followed by 'et al.'
//             Text(
//               book.authors.length > 1
//                   ? '${book.authors[0].name} et al.'
//                   : book.authors[0].name,
//             ),
//             // Add a mean rating
//             // If there are no ratings, show '0 ⭐ (0)'
//             // If there are ratings, show the mean rating
//             // followed by the number of ratings in brackets
//             Text(
//               ratings.length == 0
//                   ? '0 ⭐ (0)'
//                   : _meanRating.toStringAsFixed(1) +
//                       ' ⭐ (' +
//                       ratings.length.toString() +
//                       ')',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
