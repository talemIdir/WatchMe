import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/credit_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/models/images_model.dart';
import 'package:movies_clone/models/movies_model.dart';
import 'package:movies_clone/models/search_result.dart';
import 'package:movies_clone/models/serie_model.dart';

// ignore: camel_case_types
class API_Manager {
  final String apiKey = 'ef6fa4b419d2735837fb070d17ab75bd';

  var _topRatedMoviesUrl = Uri.https(
      'api.themoviedb.org', '/3/movie/top_rated', {
    'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
    'language': 'en-US',
    'page': '1'
  });

  var _topRatedSeriesUrl = Uri.https('api.themoviedb.org', '/3/tv/top_rated', {
    'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
    'language': 'en-US',
    'page': '1'
  });

  var _popularSeriesUrl = Uri.https('api.themoviedb.org', '/3/tv/popular', {
    'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
    'language': 'en-US',
    'page': '1'
  });

  var _onAirSeriesUrl = Uri.https('api.themoviedb.org', '/3/tv/on_the_air', {
    'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
    'language': 'en-US',
    'page': '1'
  });

  var _trendingMoviesUrl =
      Uri.https('api.themoviedb.org', '/3/trending/movie/day', {
    'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
  });

  var _moviesCategoriesUrl =
      Uri.https('api.themoviedb.org', '/3/genre/movie/list', {
    'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
    'language': 'en-US',
  });

  var _seriesCategoriesUrl =
      Uri.https('api.themoviedb.org', '/3/genre/tv/list', {
    'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
    'language': 'en-US',
  });

  Future<Images> getMovieImages(int id) async {
    Uri _imagesUrl = Uri.https('api.themoviedb.org', '/3/movie/$id/images', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en',
    });

    var dataModel;

    try {
      var response = await http.get(_imagesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedJson = json.decode(jsonString);

        dataModel = Images.fromJson(decodedJson);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<Images> getSerieImages(int id) async {
    Uri _imagesUrl = Uri.https('api.themoviedb.org', '/3/tv/$id/images', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en',
    });

    var dataModel;

    try {
      var response = await http.get(_imagesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var decodedJson = json.decode(jsonString);

        dataModel = Images.fromJson(decodedJson);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<Credit> getMovieCredits(int id) async {
    Uri _creditsUrl = Uri.https('api.themoviedb.org', '/3/movie/$id/credits', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
    });

    var dataModel;

    try {
      var response = await http.get(_creditsUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = creditFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<Credit> getSerieCredits(int id) async {
    Uri _creditsUrl = Uri.https('api.themoviedb.org', '/3/tv/$id/credits', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
    });

    var dataModel;

    try {
      var response = await http.get(_creditsUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = creditFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<SearchResultModel> searchByKeyword(String keyword) async {
    Uri _keywordSearchUrl = Uri.https('api.themoviedb.org', '/3/search/movie',
        {'api_key': 'ef6fa4b419d2735837fb070d17ab75bd', 'query': keyword});

    var dataModel;
    var response;
    try {
      response = await http.get(_keywordSearchUrl);

      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = keywordSearchFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }
    return dataModel;
  }

  Future<DataModel> searchByGenres(List<String> genres, String type,
      String orderBy, String direction) async {
    String stringGenres = genres.join(",");
    String orderByString = orderBy + "." + direction;

    final Map<String, String> movieQueryParameters = {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
      'sort_by': orderByString,
      'include_adult': 'false',
      'with_genres': stringGenres
    };

    final Map<String, String> serieQueryParameters = {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
      'sort_by': orderByString,
      'include_null_first_air_dates': 'false',
      'with_genres': stringGenres
    };

    if (genres.isEmpty) {
      movieQueryParameters.remove('with_genres');
      serieQueryParameters.remove('with_genres');
    }

    Uri _movieSearchUrl = Uri.https(
        'api.themoviedb.org', '/3/discover/movie', movieQueryParameters);

    Uri _serieSearchUrl =
        Uri.https('api.themoviedb.org', '/3/discover/tv', serieQueryParameters);

    var dataModel;
    var response;

    try {
      if (type == "movie")
        response = await http.get(_movieSearchUrl);
      else
        response = await http.get(_serieSearchUrl);

      if (response.statusCode == 200) {
        var jsonString = response.body;
        if (type == "movie")
          dataModel = movieFromJson(jsonString);
        else
          dataModel = serieFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }
    return dataModel;
  }

  Future<Movie> getMovieDetail(int id) async {
    Uri _movieDetailUrl = Uri.https('api.themoviedb.org', '/3/movie/$id', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
    });
    var dataModel;

    try {
      var response = await http.get(_movieDetailUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = movieDetailFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<Serie> getSerieDetail(int id) async {
    Uri _movieDetailUrl = Uri.https('api.themoviedb.org', '/3/tv/$id', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
    });
    var dataModel;

    try {
      var response = await http.get(_movieDetailUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = serieDetailFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<DataModel> getOnAirSeries() async {
    var dataModel;
    try {
      var response = await http.get(_onAirSeriesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = serieFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<DataModel> getPopularSeries() async {
    var dataModel;
    try {
      var response = await http.get(_popularSeriesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = serieFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<DataModel> getTopratedSeries() async {
    var dataModel;
    try {
      var response = await http.get(_topRatedSeriesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        dataModel = serieFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return dataModel;
  }

  Future<DataModel> getSimilarMovies(int movieID) async {
    var moviesModel;

    var _similarMoviesUrl = Uri.https(
        'api.themoviedb.org', '/3/movie/$movieID/similar', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
      'page': '1'
    });

    try {
      var response = await http.get(_similarMoviesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        moviesModel = movieFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return moviesModel;
  }

  Future<DataModel> getSimilarSeries(int serieID) async {
    var moviesModel;

    var _similarMoviesUrl = Uri.https(
        'api.themoviedb.org', '/3/tv/$serieID/similar', {
      'api_key': 'ef6fa4b419d2735837fb070d17ab75bd',
      'language': 'en-US',
      'page': '1'
    });

    try {
      var response = await http.get(_similarMoviesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        moviesModel = serieFromJson(jsonString);
      }
    } catch (Exception) {
      return moviesModel;
    }

    return moviesModel;
  }

  Future<DataModel> getTopratedMovies() async {
    var moviesModel;

    try {
      var response = await http.get(_topRatedMoviesUrl);
      if (response.statusCode == 200) {
        var jsonString = response.body;

        moviesModel = movieFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }

    return moviesModel;
  }

  Future<DataModel> getTrending() async {
    var moviesModel;

    try {
      var response = await http.get(_trendingMoviesUrl);

      if (response.statusCode == 200) {
        var jsonString = response.body;

        moviesModel = movieFromJson(jsonString);
      }
    } catch (Exception) {
      throw (Exception);
    }
    return moviesModel;
  }

  Future<List<Category>> getMoviesCategories() async {
    var categoriesModel;

    try {
      var response = await http.get(_moviesCategoriesUrl);

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonResponse = json.decode(jsonString);

        categoriesModel = CategoriesModel.fromJson(jsonResponse).categories;
      }
    } catch (Exception) {
      throw (Exception);
    }
    return categoriesModel;
  }

  Future<List<Category>> getSeriesCategories() async {
    var categoriesModel;

    try {
      var response = await http.get(_seriesCategoriesUrl);

      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonResponse = json.decode(jsonString);

        categoriesModel = CategoriesModel.fromJson(jsonResponse).categories;
      }
    } catch (Exception) {
      throw (Exception);
    }
    return categoriesModel;
  }
}
