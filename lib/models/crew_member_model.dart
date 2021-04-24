class CrewMember {
  int id;
  String knownFor;
  String name;
  String character;
  String profilePath;
  String job;

  CrewMember(
      {this.character,
      this.id,
      this.knownFor,
      this.name,
      this.profilePath,
      this.job});

  factory CrewMember.fromJson(Map<String, dynamic> json) => CrewMember(
        character: json['character'],
        id: json['id'],
        knownFor: json['known_for_department'],
        name: json['name'],
        profilePath: json['profile_path'],
        job: json['job'],
      );

  Map<String, dynamic> toJson() => {
        'character': character,
        'id': id,
        'known_for_department': knownFor,
        'name': name,
        'profile_path': profilePath,
        'job': job,
      };
}
