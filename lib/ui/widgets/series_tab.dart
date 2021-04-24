import 'package:flutter/material.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/ui/widgets/top_rated_home_screen.dart';
import 'package:movies_clone/ui/widgets/trending_home_screen.dart';

class SeriesTab extends StatefulWidget {
  const SeriesTab({
    Key key,
    @required this.topRatedSeries,
    @required this.imagebaseUrl,
    @required this.categoriesList,
    @required this.popularSeries,
    @required this.onAirSeries,
  });

  final Future<DataModel> topRatedSeries;
  final Future<DataModel> popularSeries;
  final Future<DataModel> onAirSeries;
  final String imagebaseUrl;
  final Future<List<Category>> categoriesList;

  @override
  _SeriesTabState createState() => _SeriesTabState();
}

class _SeriesTabState extends State<SeriesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          TopRatedHomeScreen(
            topRated: widget.topRatedSeries,
            imagebaseUrl: widget.imagebaseUrl,
            seriesCategoriesList: widget.categoriesList,
            titleText: "Top Rated",
          ),
          SizedBox(
            height: 20,
          ),
          TopRatedHomeScreen(
            topRated: widget.popularSeries,
            imagebaseUrl: widget.imagebaseUrl,
            seriesCategoriesList: widget.categoriesList,
            titleText: "Popular",
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "On the air",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          SizedBox(height: 10),
          TrendingHomeScreen(
              trending: widget.onAirSeries,
              imagebaseUrl: widget.imagebaseUrl,
              categoriesList: widget.categoriesList),
          SizedBox(
            height: 75,
          )
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
