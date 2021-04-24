class Backdrop {
  String backdropPath;

  Backdrop({this.backdropPath});

  factory Backdrop.fromJson(Map<String, dynamic> json) => Backdrop(
        backdropPath: json['file_path'],
      );
}
