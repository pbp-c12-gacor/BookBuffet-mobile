import 'package:flutter/material.dart';
import 'package:bookbuffet/pages/catalog/models/rating.dart';
import 'package:bookbuffet/pages/catalog/widgets/rating_card.dart';

class Ratings extends StatelessWidget {
  final Future<List<Rating>> ratings;
  const Ratings({Key? key, required this.ratings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rating>>(
      future: ratings,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<Rating> ratings = snapshot.data!;
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                return RatingCard(rating: ratings[index]);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No ratings yet!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
