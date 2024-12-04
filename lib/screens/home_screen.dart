import 'package:flutter/material.dart';
import 'package:helloflutter/common/utils.dart';
import 'package:helloflutter/models/tv_series_model.dart';
import 'package:helloflutter/models/upcoming_movie_model.dart';
import 'package:helloflutter/services/api_services.dart';
import 'package:helloflutter/widgets/custom_carousel_widget.dart';
import 'package:helloflutter/widgets/movie_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiServices apiServices = ApiServices();
  late Future<UpcomingMovieModel> upcomingMovies;
  late Future<UpcomingMovieModel> nowPlayingMovies;
  late Future<TvSeriesModel> topRatedSeries;

  @override
  void initState() {
    super.initState();
    upcomingMovies = apiServices.getUpcomingMovies();
    nowPlayingMovies = apiServices.getNowPlayingMovies();
    topRatedSeries = apiServices.getTopRatedSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kBackgroundColor,
            title: Image.asset("assets/logo.png", height: 50, width: 120),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  color: Colors.blue,
                  height: 27,
                  width: 27,
                ),
              ),
              const SizedBox(
                width: 20,
              )
            ]),
        body: SingleChildScrollView(
          child: Column(children: [
            FutureBuilder(
                future: topRatedSeries,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox.shrink();
                  }
                  return CustomCarouselSlider(data: snapshot.data!);
                }),
            SizedBox(
              height: 220,
              child: MovieCardWidget(
                  future: upcomingMovies, headlineText: "Upcoming Movies"),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 220,
              child: MovieCardWidget(
                  future: nowPlayingMovies, headlineText: "Now Playing Movies"),
            ),
          ]),
        ));
  }
}
