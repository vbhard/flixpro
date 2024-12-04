import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloflutter/models/popular_movie_model.dart';
import 'package:helloflutter/models/search_model.dart';
import 'package:helloflutter/screens/detail_screen.dart';
import 'package:helloflutter/services/api_services.dart';
import 'package:helloflutter/common/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  ApiServices apiServices = ApiServices();
  late Future<PopularMovieModel> popularMovies;

  SearchModel? searchModel;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    popularMovies = apiServices.getPopularMovies();
  }

  void search(String query) {
    apiServices.getSearchMovie(query).then((results) {
      setState(() {
        searchModel = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Column(children: [
        CupertinoSearchTextField(
            padding: const EdgeInsets.all(10),
            controller: searchController,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: Icon(Icons.cancel, color: Colors.grey.shade600),
            style: const TextStyle(color: Colors.white),
            backgroundColor: Colors.grey.withOpacity(0.3),
            onChanged: (value) {
              if (value.isEmpty) {
              } else {
                search(searchController.text);
              }
            }),
        searchModel == null
            ? FutureBuilder(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data?.results;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Top Searches ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                            itemCount: data!.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                  height: 150,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.network(
                                          "$imageUrl${data[index].posterPath}"),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                          width: 260,
                                          child: Text(data[index].title,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 18,
                                              ))),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    );
                  } else {
                    print("no data");
                    return const SizedBox.shrink();
                  }
                })
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchModel?.results.length ?? 0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1.2 / 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                  movieId: searchModel!.results[index].id)));
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        CachedNetworkImage(
                          imageUrl:
                              "$imageUrl${searchModel!.results[index].backdropPath}",
                          height: 170,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            searchModel!.results[index].originalTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
      ]),
    )));
  }
}
