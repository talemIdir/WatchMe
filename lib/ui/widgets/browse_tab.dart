import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_clone/api/api_manager.dart';
import 'package:movies_clone/constants/constants.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/models/search_result.dart';
import 'package:movies_clone/ui/screens/app/movie_screen.dart';
import 'package:movies_clone/ui/screens/app/serie_screen.dart';

class BrowseTab extends StatefulWidget {
  final Future<List<Category>> moviesCategoriesList;
  final Future<List<Category>> seriesCategoriesList;

  BrowseTab({
    @required this.moviesCategoriesList,
    @required this.seriesCategoriesList,
  });

  @override
  _BrowseTabState createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab>
    with AutomaticKeepAliveClientMixin {
  final int movieIndex = 0;
  final int serieIndex = 1;
  final int popularityIndex = 0, ratingIndex = 1, alphabeticalIndex = 2;
  final int descIndex = 0, ascIndex = 1;
  final List<Category> moviesCat = [];
  final List<Category> serieCat = [];
  final List<String> orderByList = [
    "popularity",
    "vote_average",
    "original_title"
  ];
  final List<String> orderDirectionList = [
    "desc",
    "asc",
  ];

  int _selected = 0;
  int _selectedOrder = 0;
  int _selectedOrderDirection = 0;
  List<String> selectedSerieCategories = [];
  List<String> selectedMovieCategories = [];

  Future<DataModel> _search;

  @override
  void initState() {
    widget.moviesCategoriesList.then((value) {
      setState(() {
        moviesCat.addAll(value);
      });
    });

    widget.seriesCategoriesList.then((value) {
      setState(() {
        serieCat.addAll(value);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: MovieOrSerieSearch());
              }),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Type",
                style: TextStyle(
                  fontSize: 20,
                  color: Constants.lightAccentColor.withAlpha(180),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            browseTypeWidget(),
            browseGenresWidget(),
            browseOrderByWidget(),
            browseButtonWidget(context),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                "Results",
                style: TextStyle(
                  fontSize: 20,
                  color: Constants.lightAccentColor.withAlpha(180),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            browseResultWidget(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  FutureBuilder<DataModel> browseResultWidget() {
    return FutureBuilder(
      future: _search,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.none:
            return Center(child: Icon(Icons.error));
            break;
          case ConnectionState.done:
            if (!snapshot.hasData)
              return Center(
                  child: Text(
                "No movies were found",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ));
            break;
          default:
        }
        if (snapshot.hasData) {
          DataModel dataModel = snapshot.data;

          if (dataModel.totalResults != 0)
            return ListView.builder(
              itemCount: dataModel.data.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Data data = dataModel.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => dataModel.type == "movie"
                                ? MovieScreen(
                                    movieID: data.id,
                                  )
                                : SerieScreen(
                                    serieID: data.id,
                                  )));
                  },
                  child: Container(
                    height: 250,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Stack(children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: data.backdropPath != null ||
                                        data.posterPath != null
                                    ? Image.network(
                                        Constants.imagebaseUrl +
                                            (data.backdropPath == null
                                                ? data.posterPath
                                                : data.backdropPath),
                                        fit: BoxFit.fill,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Text(error),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text("Error"),
                                      ),
                              ),
                              Positioned(
                                  left: 13,
                                  top: 13,
                                  child: Container(
                                    height: 25,
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Theme.of(context).primaryColor,
                                      border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 3),
                                    ),
                                    child: Text(
                                      "${data.voteAverage}",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ))
                            ]),
                          ),
                        ),
                        Text(
                          data.title,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          else
            return Center(child: Text("nothing"));
        } else
          return Center();
      },
    );
  }

  Center browseButtonWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).accentColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
          ),
          onPressed: () {
            setState(() {
              if (_selected == movieIndex)
                _search = API_Manager().searchByGenres(
                    selectedMovieCategories,
                    "movie",
                    orderByList.elementAt(_selectedOrder),
                    orderDirectionList.elementAt(_selectedOrderDirection));
              else
                _search = API_Manager().searchByGenres(
                    selectedSerieCategories,
                    "serie",
                    orderByList.elementAt(_selectedOrder),
                    orderDirectionList.elementAt(_selectedOrderDirection));
            });
          },
          child: Text(
            "Browse",
            style: TextStyle(color: Colors.white, fontSize: 23),
          ),
        ),
      ),
    );
  }

  ExpansionTile browseOrderByWidget() {
    return ExpansionTile(
      tilePadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      childrenPadding: const EdgeInsets.only(bottom: 10),
      title: Text(
        "Order by",
        style: TextStyle(
          fontSize: 20,
          color: Constants.lightAccentColor.withAlpha(180),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: [
            ChoiceChip(
              label: Text("Popularity"),
              avatar: Icon(Icons.poll_rounded, size: 16),
              selected: _selectedOrder == popularityIndex ? true : false,
              selectedColor: Colors.cyanAccent.withAlpha(200),
              backgroundColor: Colors.cyanAccent.withAlpha(50),
              elevation: 5,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.all(10),
              onSelected: (bool selected) {
                setState(() {
                  _selectedOrder = popularityIndex;
                });
              },
            ),
            ChoiceChip(
              label: Text("Rating"),
              avatar: Icon(Icons.star, size: 16),
              selected: _selectedOrder == ratingIndex ? true : false,
              selectedColor: Colors.cyanAccent.withAlpha(200),
              backgroundColor: Colors.cyanAccent.withAlpha(50),
              elevation: 5,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.all(10),
              onSelected: (bool selected) {
                setState(() {
                  _selectedOrder = ratingIndex;
                });
              },
            ),
            ChoiceChip(
              label: Text("Alphabeticaly"),
              avatar: Icon(Icons.sort_by_alpha, size: 16),
              selected: _selectedOrder == alphabeticalIndex ? true : false,
              selectedColor: Colors.cyanAccent.withAlpha(200),
              backgroundColor: Colors.cyanAccent.withAlpha(50),
              elevation: 5,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.all(10),
              onSelected: (bool selected) {
                setState(() {
                  _selectedOrder = alphabeticalIndex;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: [
            ChoiceChip(
              label: Text("DESC"),
              avatar: Icon(CupertinoIcons.sort_down, size: 16),
              selected: _selectedOrderDirection == descIndex ? true : false,
              selectedColor: Colors.yellowAccent.withAlpha(200),
              backgroundColor: Colors.yellowAccent.withAlpha(50),
              elevation: 5,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.all(10),
              onSelected: (bool selected) {
                setState(() {
                  _selectedOrderDirection = descIndex;
                });
              },
            ),
            ChoiceChip(
              label: Text("ASC"),
              avatar: Icon(CupertinoIcons.sort_up, size: 16),
              selected: _selectedOrderDirection == ascIndex ? true : false,
              selectedColor: Colors.yellowAccent.withAlpha(200),
              backgroundColor: Colors.yellowAccent.withAlpha(50),
              elevation: 5,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.all(10),
              onSelected: (bool selected) {
                setState(() {
                  _selectedOrderDirection = ascIndex;
                });
              },
            ),
          ],
        )
      ],
    );
  }

  ExpansionTile browseGenresWidget() {
    return ExpansionTile(
      tilePadding: const EdgeInsets.all(20),
      title: Text(
        "Genres",
        style: TextStyle(
          fontSize: 20,
          color: Constants.lightAccentColor.withAlpha(180),
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: _selected == movieIndex
              ? movieCategoriesWidget()
              : serieCategoriesWidget(),
        ),
      ],
    );
  }

  Container browseTypeWidget() {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChoiceChip(
            label: Text("Movie"),
            avatar: Icon(Icons.movie),
            selected: _selected == movieIndex ? true : false,
            selectedColor: Colors.blueAccent.withAlpha(200),
            backgroundColor: Colors.blueAccent.withAlpha(50),
            elevation: 8,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            padding: EdgeInsets.all(10),
            onSelected: (bool selected) {
              selectedSerieCategories.clear();
              setState(() {
                _selected = movieIndex;
              });
            },
          ),
          SizedBox(width: 20),
          ChoiceChip(
            label: Text("Serie"),
            avatar: Icon(Icons.tv),
            selected: _selected == serieIndex ? true : false,
            selectedColor: Colors.orangeAccent.withAlpha(200),
            elevation: 8,
            backgroundColor: Colors.orangeAccent.withAlpha(50),
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            padding: EdgeInsets.all(10),
            onSelected: (bool selected) {
              selectedMovieCategories.clear();
              setState(() {
                _selected = serieIndex;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget serieCategoriesWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Wrap(
        runSpacing: 5,
        spacing: 5,
        children: serieCat.map((e) {
          return ChoiceChip(
              label: Text(e.name),
              elevation: 5,
              selected: selectedSerieCategories.contains("${e.id}"),
              selectedColor: Colors.tealAccent.withAlpha(200),
              backgroundColor: Colors.tealAccent.withAlpha(50),
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              padding: EdgeInsets.all(8),
              onSelected: (bool selected) {
                setState(() {
                  if (!selected)
                    selectedSerieCategories.remove("${e.id}");
                  else
                    selectedSerieCategories.add("${e.id}");
                });
              });
        }).toList(),
      ),
    );
  }

  Widget movieCategoriesWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Wrap(
        runSpacing: 5,
        spacing: 5,
        children: moviesCat.map((e) {
          return ChoiceChip(
              label: Text(e.name),
              elevation: 5,
              selected: selectedMovieCategories.contains("${e.id}"),
              selectedColor: Colors.redAccent.withAlpha(200),
              backgroundColor: Colors.redAccent.withAlpha(50),
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              padding: EdgeInsets.all(8),
              onSelected: (bool selected) {
                setState(() {
                  if (!selected)
                    selectedMovieCategories.remove("${e.id}");
                  else
                    selectedMovieCategories.add("${e.id}");
                });
              });
        }).toList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MovieOrSerieSearch extends SearchDelegate<String> {
  Future<SearchResultModel> suggestedData;
  SearchResultModel searchResultModel;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(CupertinoIcons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: searchResultModel.data.length,
      itemBuilder: (context, index) {
        SearchResult result = searchResultModel.data[index];
        return ListTile(
            title: Text(result.title),
            subtitle: Text("${result.id}"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieScreen(
                            movieID: result.id,
                          )));
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestedData = API_Manager().searchByKeyword(query);
    return FutureBuilder(
      future: suggestedData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SearchResultModel searchResultModel = snapshot.data;
          return ListView.builder(
            itemCount: searchResultModel.data.length,
            itemBuilder: (context, index) {
              SearchResult result = searchResultModel.data[index];
              return ListTile(
                  title: Text(result.title),
                  subtitle: Text("${result.id}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieScreen(
                                  movieID: result.id,
                                )));
                  });
            },
          );
        } else
          return Text("loading");
      },
    );
  }
}
