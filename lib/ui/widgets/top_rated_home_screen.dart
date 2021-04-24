import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/ui/screens/app/movie_screen.dart';
import 'package:movies_clone/ui/screens/app/serie_screen.dart';

class TopRatedHomeScreen extends StatelessWidget {
  const TopRatedHomeScreen({
    Key key,
    @required this.topRated,
    @required this.imagebaseUrl,
    this.moviesCategoriesList,
    @required this.titleText,
    this.seriesCategoriesList,
  }) : super(key: key);

  final Future<DataModel> topRated;
  final String imagebaseUrl;
  final Future<List<Category>> moviesCategoriesList;
  final Future<List<Category>> seriesCategoriesList;
  final String titleText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            titleText,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 8, 66)),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 320,
          child: FutureBuilder(
            future: topRated,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData)
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.data.length > 10
                        ? 10
                        : snapshot.data.data.length,
                    itemBuilder: (BuildContext context, index) {
                      Data data = snapshot.data.data[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      snapshot.data.type == "movie"
                                          ? MovieScreen(
                                              movieID: data.id,
                                            )
                                          : SerieScreen(serieID: data.id)));
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10, left: 20),
                          height: 320,
                          width: 180,
                          child: Column(
                            children: [
                              Container(
                                width: 180,
                                height: 265,
                                child: data.posterPath != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          imagebaseUrl + data.posterPath,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Text(
                                              "An error has occured",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ));
                                          },
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                        .cumulativeBytesLoaded
                                                        .toDouble() /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                        .toDouble(),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                      ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${data.title}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
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
                                        unratedColor:
                                            Colors.amber.withAlpha(100),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
          ),
        ),
      ],
    );
  }
}
