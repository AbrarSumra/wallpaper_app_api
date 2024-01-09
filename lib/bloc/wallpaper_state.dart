part of 'wallpaper_bloc.dart';

abstract class WallpaperState {}

class WallpaperInitialState extends WallpaperState {}

class WallpaperLoadingState extends WallpaperState {}

class WallpaperLoadedState extends WallpaperState {
  WallpaperModel loadedData;

  WallpaperLoadedState({required this.loadedData});
}

class WallpaperErrorState extends WallpaperState {
  String errorMsg;

  WallpaperErrorState({required this.errorMsg});
}
