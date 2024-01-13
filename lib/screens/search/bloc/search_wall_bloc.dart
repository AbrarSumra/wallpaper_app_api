import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wscube_wallpaper_app/data_source/remote/api_exception.dart';
import 'package:wscube_wallpaper_app/data_source/remote/urls.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';

import '../../../data_source/remote/api_helper.dart';

part 'search_wall_event.dart';
part 'search_wall_state.dart';

class SearchWallBloc extends Bloc<SearchWallEvent, SearchWallState> {
  ApiHelper apiHelper;

  SearchWallBloc({required this.apiHelper}) : super(SearchWallInitialState()) {
    on<GetSearchWallpaper>((event, emit) async {
      emit(SearchWallLoadingState());

      try {
        var mainUrl = event.query!.isNotEmpty
            ? "${Urls.SEARCH_WALLPAPER_URL}?query=${event.query}&color=${event.colorCode}&page=${event.page}"
            : "${Urls.SEARCH_WALLPAPER_URL}?query=${event.colorCode}";

        var rawData = await apiHelper.getApi(mainUrl);

        /// Loaded State
        var searchWallpaper = WallpaperModel.fromJson(rawData);
        emit(SearchWallLoadedState(searchData: searchWallpaper));
      } catch (e) {
        /// Error State
        emit(SearchWallErrorState(errorMsg: (e as AppException).toErrorMsg()));
      }
    });
  }
}
