import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wscube_wallpaper_app/widget_constant/edited_button.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key, required this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Theme Screen",
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
      ),*/
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          Image.network(
            imageUrl!,
            fit: BoxFit.fitHeight,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditedButton(
                    heroTag: "Info",
                    onTap: () {},
                    icon: CupertinoIcons.info_circle_fill,
                    name: "Info",
                  ),
                  EditedButton(
                    heroTag: "Save",
                    onTap: () {
                      saveWallpaper(context);
                    },
                    icon: Icons.file_download_outlined,
                    name: "Save",
                  ),
                  EditedButton(
                    heroTag: "Apply",
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    applyWallpaper(context, 0);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Set to home screen",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    applyWallpaper(context, 1);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Set to lock screen",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    applyWallpaper(context, 2);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Set as both",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: CupertinoIcons.paintbrush,
                    btnColor: Colors.blue,
                    iconColor: Colors.white,
                    name: "Apply",
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Apply the Photo on Mobile
  void applyWallpaper(BuildContext context, int flag) {
    var imgStream = Wallpaper.imageDownloadProgress(imageUrl!);

    imgStream.listen(
      (event) {},
      onDone: () {
        if (flag == 0) {
          Wallpaper.homeScreen(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            options: RequestSizeOptions.RESIZE_FIT,
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Applied the Wallpaper on Home Screen!!!")));
        } else if (flag == 1) {
          Wallpaper.lockScreen(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            options: RequestSizeOptions.RESIZE_FIT,
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Applied the Wallpaper on Lock Screen!!!")));
        } else if (flag == 2) {
          Wallpaper.bothScreen(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            options: RequestSizeOptions.RESIZE_FIT,
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Applied the Wallpaper on Both Screen!!!")));
        }
      },
      onError: (e) {},
    );
  }

  /// Save the Wallpaper in File Manager
  void saveWallpaper(BuildContext context) {
    GallerySaver.saveImage(imageUrl!).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Downloaded the Wallpaper!!!")));
    });
  }
}
