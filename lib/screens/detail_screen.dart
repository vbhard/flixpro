import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helloflutter/common/utils.dart';
import 'package:helloflutter/models/movie_detail_model.dart';
import 'package:helloflutter/models/movie_recommendation_model.dart';
import 'package:helloflutter/services/api_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;
  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DetailScreen> {
  ApiServices apiServices = ApiServices();
  late Future<MovieDetailModel> movieDetail;
  late Future<MovieRecommendationModel> movieRecommendation;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetail(widget.movieId);
    movieRecommendation = apiServices.getMovieRecommendations(widget.movieId);
    controller = WebViewController()
      ..loadRequest(
          //Uri.parse('http://127.0.0.1:5500/lib/html/home.html'),
          Uri.dataFromString(
              """<iframe src="https://www.2embed.cc/embed/${widget.movieId}
      width="100%" height="100%" frameborder="0" scrolling="no"
      allowfullscreen></iframe>""",
              mimeType: "text/html"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: movieDetail,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final movie = snapshot.data;
              print(movie.toString());
              String genreText =
                  movie!.genres.map((genre) => genre.name).join(', ');
              return Column(
                children: [
                  Stack(children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage("$imageUrl${movie!.backdropPath}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ])),
                  ]),
                  const SizedBox(height: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Text(
                              genreText,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 30),
                        Text(
                          movie.overview,
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        )
                      ]),
                  const SizedBox(height: 30),
                  FutureBuilder(
                      future: movieRecommendation,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final movieRecommendations = snapshot.data;
                          return movieRecommendations!.results.isEmpty
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Text("More like this"),
                                      SizedBox(height: 20),
                                      GridView.builder(
                                          itemCount: movieRecommendations!
                                              .results.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 15,
                                                  crossAxisSpacing: 5,
                                                  childAspectRatio: 1.5 / 2),
                                          itemBuilder: (content, index) {
                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(
                                                                movieId:
                                                                    movieRecommendations
                                                                        .results[
                                                                            index]
                                                                        .id)));
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "$imageUrl${movieRecommendations.results[index].posterPath}",
                                              ),
                                            );
                                          })
                                    ]);
                        } else {
                          return const Text("error");
                        }
                      }),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
