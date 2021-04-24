import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/ui/screens/app/movie_screen.dart';
import 'package:movies_clone/ui/screens/app/serie_screen.dart';

class TrendingHomeScreen extends StatelessWidget {
  TrendingHomeScreen(
      {Key key,
      @required this.trending,
      @required this.imagebaseUrl,
      @required this.categoriesList})
      : super(key: key);

  final Future<DataModel> trending;
  final String imagebaseUrl;
  final Future<List<Category>> categoriesList;
  final List<Category> categoriesLists = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: trending,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData)
          return ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                Data data = snapshot.data.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => snapshot.data.type == "movie"
                                ? MovieScreen(
                                    movieID: data.id,
                                  )
                                : SerieScreen(
                                    serieID: data.id,
                                  )));
                  },
                  child: Container(
                    height: 200,
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(150, 13, 8, 66),
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(0, 1),
                                )
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(imagebaseUrl + data.posterPath,
                                height: 200, scale: 0.1, fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.title,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                SizedBox(height: 5),
                                RatingBarIndicator(
                                  rating: (data.voteAverage) * 5 / 10,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  },
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: Colors.amber.withAlpha(100),
                                ),
                                SizedBox(height: 5),
                                Expanded(
                                    child: getMovieCategoriesWidgets(
                                        data.genreIds)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  FutureBuilder getMovieCategoriesWidgets(List<int> list) {
    List<Widget> widgetlist = [];
    return FutureBuilder(
        future: categoriesList,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<Category> categories = snapshot.data;
            for (int i in list) {
              String categoryName =
                  categories.firstWhere((element) => element.id == i).name;
              widgetlist.add(
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 13, 8, 66),
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    categoryName,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return Wrap(
              spacing: 4,
              runSpacing: 2,
              children: widgetlist,
            );
          } else
            return Text("Not yet");
        });
  }
}
