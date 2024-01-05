class WallpaperModel {
  num? page;
  num? per_page;
  List<PhotosModel>? photos;
  num? total_results;
  String? next_page;

  WallpaperModel({
    required this.page,
    required this.per_page,
    required this.photos,
    required this.total_results,
    required this.next_page,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    List<PhotosModel> allPhotos = [];

    for (Map<String, dynamic> eachPhoto in json["photos"]) {
      allPhotos.add(PhotosModel.fromJson(eachPhoto));
    }

    return WallpaperModel(
      page: json["page"],
      per_page: json["per_page"],
      photos: allPhotos,
      total_results: json["total_results"],
      next_page: json["next_page"],
    );
  }
}

class PhotosModel {
  num? id;
  num? width;
  num? height;
  String? url;
  String? photographer;
  String? photographer_url;
  num? photographer_id;
  String? avg_color;
  SrcModel? src;
  bool? liked;
  String? alt;

  PhotosModel({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographer_url,
    required this.photographer_id,
    required this.avg_color,
    required this.src,
    required this.liked,
    required this.alt,
  });

  factory PhotosModel.fromJson(Map<String, dynamic> json) {
    return PhotosModel(
      id: json["id"],
      width: json["width"],
      height: json["height"],
      url: json["url"],
      photographer: json["photographer"],
      photographer_url: json["photographer_url"],
      photographer_id: json["photographer_id"],
      avg_color: json["avg_color"],
      src: SrcModel.fromJson(json["src"]),
      liked: json["liked"],
      alt: json["alt"],
    );
  }
}

class SrcModel {
  String? original;
  String? large2x;
  String? large;
  String? medium;
  String? small;
  String? portrait;
  String? landscape;
  String? tiny;

  SrcModel({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory SrcModel.fromJson(Map<String, dynamic> json) {
    return SrcModel(
      original: json["original"],
      large2x: json["large2x"],
      large: json["large"],
      medium: json["medium"],
      small: json["small"],
      portrait: json["portrait"],
      landscape: json["landscape"],
      tiny: json["tiny"],
    );
  }
}
