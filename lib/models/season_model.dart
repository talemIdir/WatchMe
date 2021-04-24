import 'dart:convert';

Season seasonFromJson(String str) => Season.fromJson(json.decode(str));
String seasonToJson(Season data) => json.encode(data.toJson());

class Season {
  DateTime airDate;
  int numberEpisodes;
  int id;
  String name;
  String overview;
  String posterPath;
  int seasonNumber;

  Season({
    this.airDate,
    this.id,
    this.name,
    this.numberEpisodes,
    this.overview,
    this.posterPath,
    this.seasonNumber,
  });

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        airDate:
            json['air_date'] == null ? null : DateTime.parse(json['air_date']),
        id: json['id'],
        name: json['name'],
        numberEpisodes: json['episode_count'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "id": id,
        "name": name,
        "episode_count": numberEpisodes,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };
}
