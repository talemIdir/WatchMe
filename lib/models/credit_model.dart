import 'dart:convert';

import 'package:movies_clone/models/cast_member_model.dart';
import 'package:movies_clone/models/crew_member_model.dart';

Credit creditFromJson(String str) => Credit.fromJson(json.decode(str));

class Credit {
  List<CastMember> cast;
  List<CrewMember> crew;

  Credit({this.cast, this.crew});

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        cast: List<CastMember>.from(
            json['cast'].map((e) => CastMember.fromJson(e))),
        crew: List<CrewMember>.from(
            json['crew'].map((e) => CrewMember.fromJson(e))),
      );
}
