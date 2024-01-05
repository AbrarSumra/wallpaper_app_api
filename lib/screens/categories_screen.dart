import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';
import 'package:http/http.dart' as https;
import 'package:wscube_wallpaper_app/screens/theme_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  WallpaperModel? wallpaperModel;

  @override
  void initState() {
    super.initState();
    getAllPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Category Screen",
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
                  Text(
                    "${wallpaperModel!.photos!.length} Wallpaper available",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  wallpaperModel != null && wallpaperModel!.photos!.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 5,
                          ),
                          itemCount: wallpaperModel!.photos!.length,
                          itemBuilder: (_, catIndex) {
                            var catPhoto = wallpaperModel!
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
                                        wallpaperModel!
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
                          })
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getAllPhotos() async {
    var myApi = "sxkQNVewOd8AFlFs0P7xf1vpnVM7TdILxUROfB1h57qFspAhfFhx0evm";
    var uri = Uri.parse("https://api.pexels.com/v1/search?query=nature");
    var response = await https.get(uri, headers: {
      "Authorization": myApi,
    });

    if (response.statusCode == 200) {
      var mData = jsonDecode(response.body);
      wallpaperModel = WallpaperModel.fromJson(mData);
      setState(() {});
    }
  }
}
