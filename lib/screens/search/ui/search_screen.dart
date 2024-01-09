import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';
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
                  Text(
                    widget.upcomingSearch.toString().toUpperCase(),
                    style: const TextStyle(
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      catPhoto,
                                      fit: BoxFit.cover,
                                    ),
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
}
