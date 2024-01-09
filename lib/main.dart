import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wscube_wallpaper_app/bloc/wallpaper_bloc.dart';
import 'package:wscube_wallpaper_app/data_source/remote/api_helper.dart';
import 'package:wscube_wallpaper_app/screens/wallpaper_screen.dart';

import 'screens/download_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => WallpaperBloc(apiHelper: ApiHelper()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screen = [
    const WallpaperScreen(),
    const DownloadScreen(),
    const ProfileScreen(),
  ];

  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                _changeScreen(0);
              },
              child: const Image(
                image: AssetImage("assets/images/menu.png"),
                height: 25,
                width: 25,
              ),
            ),
            InkWell(
              onTap: () {
                _changeScreen(1);
              },
              child: const Icon(
                Icons.file_download_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
            InkWell(
              onTap: () {
                _changeScreen(2);
              },
              child: const Icon(
                CupertinoIcons.person,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
