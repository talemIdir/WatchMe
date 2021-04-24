class Poster {
  String posterPath;

  Poster({this.posterPath});

  factory Poster.fromJson(Map<String, dynamic> json) => Poster(
        posterPath: json['file_path'],
      );
}
