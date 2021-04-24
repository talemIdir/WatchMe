import 'package:movies_clone/models/backdrop_model.dart';
import 'package:movies_clone/models/poster_model.dart';

class Images {
  List<Poster> posters;
  List<Backdrop> backdrops;

  Images({this.backdrops, this.posters});

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        posters:
            List<Poster>.from(json['posters'].map((p) => Poster.fromJson(p))),
        backdrops: List<Backdrop>.from(
            json['backdrops'].map((b) => Backdrop.fromJson(b))),
      );
}
