import 'dart:convert';

DataModel movieFromJson(String str) =>
    DataModel.fromJson(json.decode(str), "movie");
DataModel serieFromJson(String str) =>
    DataModel.fromJson(json.decode(str), "serie");

String newsModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  int page;
  List<Data> data;
  int totalPages;
  int totalResults;
  String type;

  DataModel(
      {this.data, this.page, this.totalPages, this.totalResults, this.type});

  factory DataModel.fromJson(Map<String, dynamic> json, String type) =>
      DataModel(
        type: type,
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        data: type == "serie"
            ? List<Data>.from(json["results"].map((x) => Data.serieFromJson(x)))
            : List<Data>.from(
                json["results"].map((x) => Data.movieFromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "total_results": totalResults,
        "total_pages": totalResults,
        "results": type == "serie"
            ? List<dynamic>.from(data.map((x) => x.serieToJson()))
            : List<dynamic>.from(data.map((x) => x.movieToJson())),
      };
}

class Data {
  String posterPath;
  double popularity;
  int id;
  String backdropPath;
  String overview;
  DateTime releaseDate;
  List<int> genreIds = [];
  String originalLanguage;
  int voteCount;
  double voteAverage;
  String originalTitle;
  String title;
  bool adult;
  bool video;

  Data({
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.overview,
    this.popularity,
    this.posterPath,
    this.voteAverage,
    this.voteCount,
    this.originalTitle,
    this.releaseDate,
    this.title,
    this.adult,
    this.video,
  });

  factory Data.serieFromJson(Map<String, dynamic> json) => Data(
        title: json["name"],
        releaseDate: json["first_air_date"] == null
            ? DateTime.parse(json["first_air_date"])
            : null,
        backdropPath: json["backdrop_path"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble() as double,
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble() as double,
        voteCount: json["vote_count"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
      );

  factory Data.movieFromJson(Map<String, dynamic> json) => Data(
        adult: json["adult"] == "false" ? false : true,
        title: json["title"],
        releaseDate: json["release_date"] == null
            ? null
            : DateTime.parse(json["release_date"]),
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble() as double,
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        voteAverage: json["vote_average"].toDouble() as double,
        voteCount: json["vote_count"],
        video: json["video"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
      );

  Map<String, dynamic> serieToJson() => {
        "first_air_date": releaseDate,
        "name": title,
        "original_language": originalLanguage,
        "backdrop_path": backdropPath,
        "id": id,
        "original_name": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteAverage,
      };

  Map<String, dynamic> movieToJson() => {
        "adult": adult,
        "title": title,
        "original_language": originalLanguage,
        "backdrop_path": backdropPath,
        "id": id,
        "release_date": releaseDate.toIso8601String(),
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteAverage,
        "video": video,
      };
}
