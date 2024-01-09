import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wscube_wallpaper_app/data_source/remote/api_exception.dart';
import 'package:wscube_wallpaper_app/data_source/remote/api_helper.dart';
import 'package:wscube_wallpaper_app/data_source/remote/urls.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  ApiHelper apiHelper;

  WallpaperBloc({required this.apiHelper}) : super(WallpaperInitialState()) {
    on<GetTrendingWallpaper>((event, emit) async {
      emit(WallpaperLoadingState());

      try {
        var rawData = await apiHelper.getApi(Urls.TRENDING_WALLPAPER_URL);
        var wallpaperDataModel = WallpaperModel.fromJson(rawData);
        emit(WallpaperLoadedState(loadedData: wallpaperDataModel));
      } catch (e) {
        emit(WallpaperErrorState(errorMsg: (e as AppException).toErrorMsg()));
      }
    });
  }
}
