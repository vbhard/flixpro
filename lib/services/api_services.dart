import 'dart:convert';
import 'dart:developer';

import 'package:helloflutter/common/utils.dart';
import 'package:helloflutter/models/movie_detail_model.dart';
import 'package:helloflutter/models/movie_recommendation_model.dart';
import 'package:helloflutter/models/search_model.dart';
import 'package:helloflutter/models/tv_series_model.dart';
import 'package:helloflutter/models/upcoming_movie_model.dart';
import 'package:helloflutter/models/popular_movie_model.dart';
import 'package:http/http.dart';

var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Loaded Upcoming data from $url");
      return UpcomingMovieModel.fromJson(json.decode(response.body));
    }
    log("Error in REST call $response.body");
    throw Exception("Failed to load data");
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";
    log("Loaded Now Playing data from $url");
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      return UpcomingMovieModel.fromJson(json.decode(response.body));
    }
    log("Error in REST call $response.body");
    throw Exception("Failed to load data");
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    endPoint = "tv/top_rated";
    final url = "$baseUrl$endPoint$key";
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      return TvSeriesModel.fromJson(json.decode(response.body));
    }
    log("Error in REST call $response.body");
    throw Exception("Failed to load data");
  }

  Future<SearchModel> getSearchMovie(String searchText) async {
    endPoint = "search/movie?query=$searchText";
    final url = "$baseUrl$endPoint";
    final response = await get(Uri.parse(url), headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      log("SearchMoviescall successful: $url");
      return SearchModel.fromJson(json.decode(response.body));
    }
    log("Error in REST call $response.body");
    throw Exception("Failed to load search Results");
  }

  Future<PopularMovieModel> getPopularMovies() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint";
    final response = await get(Uri.parse(url), headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      log("Popular Movies call successful: $url");
      return PopularMovieModel.fromJson(json.decode(response.body));
    }
    log("Error in REST call $response.body");
    throw Exception("Failed to load search Popular Movies");
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    endPoint = "movie/$movieId";
    final url = "$baseUrl$endPoint";
    final response = await get(Uri.parse(url), headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      log("Search Movies Detailcall successful: $url");
      return MovieDetailModel.fromJson(json.decode(response.body));
    }
    log("Error in REST call $response.body");
    throw Exception("Failed to load Movie Detail Results");
  }

  Future<MovieRecommendationModel> getMovieRecommendations(int movieId) async {
    endPoint = "movie/$movieId/recommendations";
    final url = "$baseUrl$endPoint";
    final response = await get(Uri.parse(url), headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      log("Search Movies Detailcall successful: $url");
      return MovieRecommendationModel.fromJson(json.decode(response.body));
    }
    log("Error in REST call $response.body");
    throw Exception("Failed to load Movie Recommendations Results");
  }
}
