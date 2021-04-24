import 'dart:convert';

import 'package:movies_clone/models/season_model.dart';

import 'categories_model.dart';

Serie serieDetailFromJson(String str) => Serie.fromJson(json.decode(str));

String serieDetailToJson(Serie data) => json.encode(data.toJson());

class Serie {
  String backdropPath;
  DateTime releaseDate;
  List<Category> genreIds = [];
  List<Season> seasons = [];
  String homepage;
  int id;
  String title;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  int voteCount;
  double voteAverage;
  String status;
  int numberSeasons;
  int numberEpisodes;

  Serie({
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.voteCount,
    this.status,
    this.homepage,
    this.numberEpisodes,
    this.numberSeasons,
    this.seasons,
  });

  factory Serie.fromJson(Map<String, dynamic> json) => Serie(
        title: json["name"] == null ? null : json["name"],
        releaseDate: json["first_air_date"] == null
            ? null
            : DateTime.parse(json["first_air_date"]),
        backdropPath:
            json["backdrop_path"] == null ? null : json["backdrop_path"],
        id: json["id"] == null ? null : json["id"],
        originalLanguage: json["original_language"] == null
            ? null
            : json["original_language"],
        originalTitle:
            json["original_name"] == null ? null : json["original_name"],
        overview: json["overview"] == null ? null : json["overview"],
        popularity: json["popularity"] == null ? null : json["popularity"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        voteAverage: json["vote_average"] == null ? null : json["vote_average"],
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
        genreIds: json["genres"] == null
            ? null
            : List<Category>.from(
                json["genres"].map((x) => Category.fromJson(x))),
        homepage: json['homepage'] == null ? null : json['homepage'],
        status: json['status'] == null ? null : json['status'],
        numberEpisodes: json['number_of_episodes'] == null
            ? null
            : json['number_of_episodes'],
        numberSeasons: json['number_of_seasons'] == null
            ? null
            : json['number_of_seasons'],
        seasons:
            List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": title,
        "original_language": originalLanguage,
        "backdrop_path": backdropPath,
        "id": id,
        "first_air_date": releaseDate.toIso8601String(),
        "original_name": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteAverage,
        "homepage": homepage,
      };
}
