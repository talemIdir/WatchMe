import 'dart:convert';

CategoriesModel newsModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String newsModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  List<Category> categories;

  CategoriesModel({this.categories});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        categories: List<Category>.from(
            json["genres"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  String name;
  int id;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
