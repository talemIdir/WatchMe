class CastMember {
  int id;
  String knownFor;
  String name;
  String character;
  String profilePath;

  CastMember(
      {this.character, this.id, this.knownFor, this.name, this.profilePath});

  factory CastMember.fromJson(Map<String, dynamic> json) => CastMember(
        character: json['character'],
        id: json['id'],
        knownFor: json['known_for_department'],
        name: json['name'],
        profilePath: json['profile_path'],
      );

  Map<String, dynamic> toJson() => {
        'character': character,
        'id': id,
        'known_for_department': knownFor,
        'name': name,
        'profile_path': profilePath,
      };
}
