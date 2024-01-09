part of 'search_wall_bloc.dart';

@immutable
abstract class SearchWallEvent {}

class GetSearchWallpaper extends SearchWallEvent {
  final String query;
  final String colorCode;

  GetSearchWallpaper({required this.query, this.colorCode = ""});
}
