import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wscube_wallpaper_app/bloc/wallpaper_bloc.dart';
import 'package:wscube_wallpaper_app/data_source/remote/api_helper.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';
import 'package:wscube_wallpaper_app/screens/search/bloc/search_wall_bloc.dart';
import 'package:wscube_wallpaper_app/screens/search/ui/search_screen.dart';

import '../modules/all_constant_list.dart';
import '../modules/category_model.dart';
import '../modules/color_model.dart';
import 'theme_screen.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  TextEditingController searchWallpaper = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<WallpaperModel?>? wallpaperModel;
  WallpaperModel? trendingWallpaper;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<WallpaperBloc>(context).add(GetTrendingWallpaper());
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    BlocProvider.of<WallpaperBloc>(context).add(GetTrendingWallpaper());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(215, 236, 237, 1),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              searchBar(),
              bestOfMonth(),
              colorTone(colorList),
              categoryWiseWallpaper(categoryWallpaper),
            ],
          ),
        ),
      ),
    );
  }

  /// Search Bar
  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchWallpaper,
              focusNode: _focusNode,
              decoration: InputDecoration(
                fillColor: Colors.white,
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
              if (searchWallpaper.text.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => BlocProvider(
                        create: (context) =>
                            SearchWallBloc(apiHelper: ApiHelper()),
                        child: SearchScreen(
                          upcomingSearch: searchWallpaper.text.toString(),
                          colorCode: "",
                        ),
                      ),
                    ));
              }
              _focusNode.unfocus();
            },
            splashColor: Colors.red,
            icon: const Icon(
              CupertinoIcons.search,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  /// Best of Month
  Widget bestOfMonth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Best of the month",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: BlocBuilder<WallpaperBloc, WallpaperState>(
                builder: (context, state) {
              if (state is WallpaperLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WallpaperLoadedState) {
                var loadPhoto = state.loadedData;
                return ListView.builder(
                    itemCount: loadPhoto.photos!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, index) {
                      var photo = loadPhoto.photos![index].src!.portrait!;
                      return Row(
                        children: [
                          SizedBox(
                            height: 200,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => ThemeScreen(
                                      imageUrl: photo,
                                    ),
                                  ));
                                },
                                child: Image.network(
                                  photo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15)
                        ],
                      );
                    });
              }
              return Container();
            }),
          ),
        ),
      ],
    );
  }

  /// Color Tone
  Widget colorTone(List<ColorModel> colorList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Text(
            "The color tone",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5),
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
                          if (searchWallpaper.text.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => BlocProvider(
                                          create: (context) => SearchWallBloc(
                                              apiHelper: ApiHelper()),
                                          child: SearchScreen(
                                              upcomingSearch: searchWallpaper
                                                  .text
                                                  .toString(),
                                              colorCode:
                                                  colorList[index].colorCode),
                                        )));
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorList[index].colorValue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15)
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  /// Category Wise Wallpaper
  Widget categoryWiseWallpaper(List<CategoryModel> catModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6 / 4,
              ),
              itemCount: catModel.length,
              itemBuilder: (_, catIndex) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => BlocProvider(
                        create: (context) =>
                            SearchWallBloc(apiHelper: ApiHelper()),
                        child: SearchScreen(
                          isCategory: true,
                          upcomingSearch: catModel[catIndex].imgName,
                          colorCode: "",
                        ),
                      ),
                    ));
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            catModel[catIndex].imgUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Center(
                          child: Text(
                            catModel[catIndex].imgName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  /*/// All Photos
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
  }*/
}
