import 'dart:convert';

SearchResultModel keywordSearchFromJson(String str) =>
    SearchResultModel.fromJson(json.decode(str));

class SearchResultModel {
  int page;
  List<SearchResult> data;
  int totalPages;
  int totalResults;

  SearchResultModel({this.data, this.page, this.totalPages, this.totalResults});

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        data: List<SearchResult>.from(
            json["results"].map((x) => SearchResult.searchResultFromJson(x))),
      );
}

class SearchResult {
  int id;
  String title;

  SearchResult({this.id, this.title});

  factory SearchResult.searchResultFromJson(Map<String, dynamic> json) =>
      SearchResult(
        id: json['id'],
        title: json['title'],
      );
}
