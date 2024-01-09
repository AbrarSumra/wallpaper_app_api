import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wscube_wallpaper_app/widget_constant/edited_button.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key, required this.imageUrl});
  final String? imageUrl;

  @override
  State<ThemeScreen> createState() => _ThemeScreen();
}

class _ThemeScreen extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          Image.network(
            widget.imageUrl!,
            fit: BoxFit.fitHeight,
            width: double.infinity,
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
                    onTap: () {},
                    icon: Icons.file_download_outlined,
                    name: "Save",
                  ),
                  EditedButton(
                    heroTag: "Apply",
                    onTap: () {},
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
}
