import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';
import 'package:wscube_wallpaper_app/screens/search/bloc/search_wall_bloc.dart';
import 'package:wscube_wallpaper_app/screens/theme_screen.dart';

import '../../../modules/color_model.dart';

class SearchScreen extends StatefulWidget {
  final String? upcomingSearch;
  final String? colorCode;

  const SearchScreen({
    super.key,
    required this.upcomingSearch,
    required this.colorCode,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  WallpaperModel? searchWallpaper;
  TextEditingController searchPhotos = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchWallBloc>(context).add(GetSearchWallpaper(
        query: widget.upcomingSearch!, colorCode: widget.colorCode!));
  }

  @override
  Widget build(BuildContext context) {
    searchPhotos.text = widget.upcomingSearch!;

    List<ColorModel> colorList = [
      ColorModel(colorValue: Colors.white, colorCode: "ffffff"),
      ColorModel(colorValue: Colors.black, colorCode: "000000"),
      ColorModel(colorValue: Colors.blue, colorCode: "0000ff"),
      ColorModel(colorValue: Colors.green, colorCode: "00ff00"),
      ColorModel(colorValue: Colors.red, colorCode: "ff0000"),
      ColorModel(colorValue: Colors.purple, colorCode: "9C27B0"),
      ColorModel(colorValue: Colors.orange, colorCode: "FF9800"),
    ];

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
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchPhotos,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        focusColor: Colors.transparent,
                        border: InputBorder.none,
                        filled: true,
                        hintText: "Find Wallpaper...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (searchPhotos.text.isNotEmpty) {
                        BlocProvider.of<SearchWallBloc>(context).add(
                            GetSearchWallpaper(
                                query: searchPhotos.text.toString()));
                        _focusNode.unfocus();
                        setState(() {});
                      }
                    },
                    splashColor: Colors.red,
                    icon: const Icon(
                      CupertinoIcons.search,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: colorList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctx, index) {
                    return Row(
                      children: [
                        InkWell(
                          //splashColor: Colors.red,
                          onTap: () {
                            BlocProvider.of<SearchWallBloc>(context).add(
                                GetSearchWallpaper(
                                    query: searchPhotos.text.toString(),
                                    colorCode: colorList[index].colorCode!));
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: colorList[index].colorValue,
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15)
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
