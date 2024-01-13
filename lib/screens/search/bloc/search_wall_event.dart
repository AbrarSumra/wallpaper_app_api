part of 'search_wall_bloc.dart';

@immutable
abstract class SearchWallEvent {}

class GetSearchWallpaper extends SearchWallEvent {
  final String? query;
  final String? colorCode;
  final int? page;

  GetSearchWallpaper({
    required this.query,
    this.colorCode = "",
    this.page = 1,
  });
}
