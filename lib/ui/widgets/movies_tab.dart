import 'package:flutter/material.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/ui/widgets/top_rated_home_screen.dart';
import 'package:movies_clone/ui/widgets/trending_home_screen.dart';

class MoviesTab extends StatefulWidget {
  const MoviesTab({
    Key key,
    @required this.topRatedMovies,
    @required this.imagebaseUrl,
    @required this.categoriesList,
    @required this.trendingMovies,
  });

  final Future<DataModel> topRatedMovies;
  final String imagebaseUrl;
  final Future<List<Category>> categoriesList;
  final Future<DataModel> trendingMovies;

  @override
  _MoviesTabState createState() => _MoviesTabState();
}

class _MoviesTabState extends State<MoviesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: ScrollPhysics(),
      children: [
        SizedBox(height: 20),
        TopRatedHomeScreen(
          topRated: widget.topRatedMovies,
          imagebaseUrl: widget.imagebaseUrl,
          moviesCategoriesList: widget.categoriesList,
          titleText: "Top Rated",
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Trending",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 8, 66)),
          ),
        ),
        SizedBox(height: 10),
        TrendingHomeScreen(
          categoriesList: widget.categoriesList,
          imagebaseUrl: widget.imagebaseUrl,
          trending: widget.trendingMovies,
        ),
        SizedBox(
          height: 75,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
