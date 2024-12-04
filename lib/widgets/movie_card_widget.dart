import 'package:flutter/material.dart';
import 'package:helloflutter/common/utils.dart';
import 'package:helloflutter/models/upcoming_movie_model.dart';
import 'package:helloflutter/screens/detail_screen.dart';

class MovieCardWidget extends StatelessWidget {
  final Future<UpcomingMovieModel> future;
  final String headlineText;

  const MovieCardWidget(
      {super.key, required this.future, required this.headlineText});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          var data = snapshot.data?.results;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headlineText,
                  style: const TextStyle(
                      //color: Colors.white,
                      //fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: data!.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          movieId: data[index].id)));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.network(
                                "$imageUrl${data[index].posterPath}",
                              ),
                            ),
                          );
                        }))
              ]);
        });
  }
}
