import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';
import 'package:http/http.dart' as https;
import 'package:wscube_wallpaper_app/screens/search/bloc/search_wall_bloc.dart';
import 'package:wscube_wallpaper_app/screens/theme_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? upcomingSearch;
  final String? colorCode;

  const SearchScreen(
      {super.key, required this.upcomingSearch, required this.colorCode});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  WallpaperModel? searchWallpaper;

  @override
  void initState() {
    super.initState();
    //wallpaperModel = getAllPhotos();
    BlocProvider.of<SearchWallBloc>(context).add(GetSearchWallpaper(
        query: widget.upcomingSearch!, colorCode: widget.colorCode!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Search Screen",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 30,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nature",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  BlocBuilder<SearchWallBloc, SearchWallState>(
                      builder: (context, state) {
                    if (state is SearchWallLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is SearchWallErrorState) {
                      return Center(
                        child: Text(state.errorMsg),
                      );
                    } else if (state is SearchWallLoadedState) {
                      searchWallpaper = state.searchData;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${searchWallpaper!.photos!.length} Wallpaper available",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.grey),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4 / 5,
                            ),
                            itemCount: searchWallpaper!.photos!.length,
                            itemBuilder: (_, catIndex) {
                              var catPhoto = searchWallpaper!
                                  .photos![catIndex].src!.landscape!;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => ThemeScreen(
                                            imageUrl: catPhoto,
                                          )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          catPhoto,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          searchWallpaper!
                                              .photos![catIndex].photographer!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<WallpaperModel?> getAllPhotos(
      {String query = "nature", String colorCode = ""}) async {
    var myApi = "sxkQNVewOd8AFlFs0P7xf1vpnVM7TdILxUROfB1h57qFspAhfFhx0evm";
    var uri = Uri.parse(
        "https://api.pexels.com/v1/search?query=$query&color=$colorCode");
    var response = await https.get(uri, headers: {
      "Authorization": myApi,
    });

    if (response.statusCode == 200) {
      var mData = jsonDecode(response.body);
      var data = WallpaperModel.fromJson(mData);
      return data;
    } else {
      return null;
    }
  }
}
