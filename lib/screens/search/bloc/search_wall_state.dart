part of 'search_wall_bloc.dart';

@immutable
abstract class SearchWallState {}

class SearchWallInitialState extends SearchWallState {}

class SearchWallLoadingState extends SearchWallState {}

class SearchWallLoadedState extends SearchWallState {
  final WallpaperModel searchData;

  SearchWallLoadedState({required this.searchData});
}

class SearchWallErrorState extends SearchWallState {
  final String errorMsg;

  SearchWallErrorState({required this.errorMsg});
}
