import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_clone/api/api_manager.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/ui/widgets/browse_tab.dart';
import 'package:movies_clone/ui/widgets/movies_tab.dart';
import 'package:movies_clone/ui/widgets/series_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;

  String imagebaseUrl = "https://image.tmdb.org/t/p/w500";

  Future<DataModel> topRatedMovies;
  Future<DataModel> trendingMovies;

  Future<List<Category>> moviesCategoriesList;
  Future<List<Category>> seriesCategoriesList;
  List<Category> categoriesLists = [];

  Future<DataModel> topRatedSeries;
  Future<DataModel> popularSeries;
  Future<DataModel> onAirSeries;

  final double position = 10;

  bool loading = true, timeout = false;

  Future<void> _getMoviesData() async {
    setState(() {
      topRatedMovies = API_Manager().getTopratedMovies();
      topRatedMovies.then((value) {
        setState(() {
          if (value != null)
            loading = false;
          else
            timeout = true;
        });
      }).timeout(const Duration(seconds: 30), onTimeout: () {
        setState(() {
          timeout = true;
        });

        return null;
      });

      trendingMovies = API_Manager().getTrending();
    });
  }

  Future<void> _getSeriesData() async {
    setState(() {
      topRatedSeries = API_Manager().getTopratedSeries();
      popularSeries = API_Manager().getPopularSeries();
      onAirSeries = API_Manager().getOnAirSeries();
    });
  }

  Future<void> _getCategories() async {
    setState(() {
      moviesCategoriesList = API_Manager().getMoviesCategories();
      seriesCategoriesList = API_Manager().getSeriesCategories();
      moviesCategoriesList.then((value) => categoriesLists = value);
    });
  }

  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    _getMoviesData();
    _getCategories();
    _getSeriesData();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    if (timeout)
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            "Timeout...",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      );
    else {
      if (loading)
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text(
              "Loading...",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        );
      else
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: () {
                        setState(() {
                          loading = true;
                        });
                        return _getMoviesData();
                      },
                      child: MoviesTab(
                        topRatedMovies: topRatedMovies,
                        imagebaseUrl: imagebaseUrl,
                        categoriesList: moviesCategoriesList,
                        trendingMovies: trendingMovies,
                      ),
                    ),
                    RefreshIndicator(
                        onRefresh: () {
                          return _getSeriesData();
                        },
                        child: SeriesTab(
                          topRatedSeries: topRatedSeries,
                          imagebaseUrl: imagebaseUrl,
                          categoriesList: seriesCategoriesList,
                          popularSeries: popularSeries,
                          onAirSeries: onAirSeries,
                        )),
                    BrowseTab(
                      moviesCategoriesList: moviesCategoriesList,
                      seriesCategoriesList: seriesCategoriesList,
                    )
                  ],
                ),
                Positioned(
                  bottom: position,
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 0),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(150, 13, 8, 66),
                            spreadRadius: 0,
                            blurRadius: 7,
                            offset: Offset(0, 1),
                          )
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: TabBar(
                        unselectedLabelColor: Color.fromARGB(255, 13, 8, 66),
                        labelColor: Colors.white,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        indicator: BoxDecoration(
                          color: Color.fromARGB(255, 13, 8, 66),
                        ),
                        tabs: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.movie),
                              Text("Movies"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.tv),
                              Text("TV"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.film),
                              Text("Browse"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
