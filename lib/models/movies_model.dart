import 'dart:convert';

import 'categories_model.dart';

Movie movieDetailFromJson(String str) => Movie.fromJson(json.decode(str));

String movieDetailToJson(Movie data) => json.encode(data.toJson());

class Movie {
  bool adult;
  String backdropPath;
  int budget;
  List<Category> genreIds = [];
  String homePage;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  int revenue;
  int runtime;
  String status;
  String title;
  bool video;
  int voteCount;
  double voteAverage;

  Movie({
    this.adult,
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
    this.video,
    this.voteAverage,
    this.voteCount,
    this.budget,
    this.homePage,
    this.revenue,
    this.runtime,
    this.status,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"] == "false" ? false : true,
        title: json["title"],
        releaseDate: DateTime.parse(json["release_date"]),
        backdropPath: json["backdrop_path"],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"],
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
        video: json["video"],
        genreIds: List<Category>.from(
            json["genres"].map((x) => Category.fromJson(x))),
        budget: json['budget'],
        homePage: json['homepage'],
        revenue: json['revenus'],
        runtime: json['runtime'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
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
        "budget": budget,
        "homepage": homePage,
        "revenus": revenue,
        "runtime": runtime,
        "status": status,
      };
}
