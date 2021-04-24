import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_clone/api/api_manager.dart';
import 'package:movies_clone/constants/constants.dart';
import 'package:movies_clone/models/cast_member_model.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/credit_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/models/images_model.dart';
import 'package:movies_clone/models/season_model.dart';
import 'package:movies_clone/models/serie_model.dart';
import 'package:movies_clone/ui/widgets/backdrops_dialog_widget.dart';
import 'package:movies_clone/ui/widgets/not_found_widget.dart';
import 'package:movies_clone/ui/widgets/posters_dialog_widget.dart';
import 'package:movies_clone/ui/widgets/season_dialog.dart';

class SerieScreen extends StatefulWidget {
  final int serieID;

  SerieScreen({@required this.serieID});

  @override
  _SerieScreenState createState() => _SerieScreenState();
}

class _SerieScreenState extends State<SerieScreen> {
  final String imagebaseUrl = "https://image.tmdb.org/t/p/w500";

  final GlobalKey seasonsExpansionTileKey = GlobalKey();
  final GlobalKey similarExpansionTileKey = GlobalKey();
  final GlobalKey castExpansionTileKey = GlobalKey();
  final GlobalKey imageExpansionTileKey = GlobalKey();

  Future<Serie> serie;
  Future<DataModel> similarSeries;
  Future<Credit> serieCredit;
  Future<Images> serieImages;

  Future<void> _getData() async {
    setState(() {
      serie = API_Manager().getSerieDetail(widget.serieID);
      similarSeries = API_Manager().getSimilarSeries(widget.serieID);
      serieCredit = API_Manager().getSerieCredits(widget.serieID);
      serieImages = API_Manager().getSerieImages(widget.serieID);
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.bodyText1.color,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
        ),
        title: Text(
          "Serie's detail",
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: serie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Serie serie = snapshot.data;
            return Container(
              width: size.width,
              child: MediaQuery.of(context).orientation == Orientation.portrait
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          seriePoster(size, serie),
                          SizedBox(height: 20),
                          serieTitle(context, serie),
                          SizedBox(height: 20),
                          serieInformations(context, serie),
                          SizedBox(height: 20),
                          Container(
                              child: Text("Overview",
                                  style:
                                      Theme.of(context).textTheme.headline3)),
                          SizedBox(height: 10),
                          serieOverview(context, serie),
                          SizedBox(height: 20),
                          serieCategories(serie.genreIds),
                          SizedBox(height: 20),
                          if (serie.seasons != null)
                            serieSeasons(serie, context, size),
                          similarSeriesWidget(context, size),
                          SizedBox(height: 10),
                          castWidget(size),
                          SizedBox(height: 10),
                          imageWidget(context),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(flex: 1, child: seriePoster(size, serie)),
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                serieTitle(context, serie),
                                SizedBox(height: 20),
                                serieInformations(context, serie),
                                SizedBox(height: 20),
                                Container(
                                    child: Text("Overview",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3)),
                                SizedBox(height: 10),
                                serieOverview(context, serie),
                                SizedBox(height: 20),
                                serieCategories(serie.genreIds),
                                SizedBox(height: 20),
                                if (serie.seasons != null)
                                  serieSeasons(serie, context, size),
                                similarSeriesWidget(context, size),
                                SizedBox(height: 10),
                                castWidget(size),
                                SizedBox(height: 10),
                                imageWidget(context),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  Widget imageWidget(BuildContext context) {
    return ExpansionTile(
      key: imageExpansionTileKey,
      onExpansionChanged: (value) {
        if (value) {
          _scrollToSelectedContent(expansionTileKey: imageExpansionTileKey);
        }
      },
      title: Text(
        "Images",
        style: Theme.of(context).textTheme.headline3,
        textAlign: TextAlign.center,
      ),
      children: [
        FutureBuilder(
          future: serieImages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Images images = snapshot.data;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return PosterDialog(
                            posters: images.posters,
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.posters.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                Constants.imagebaseUrl +
                                    images.posters[index].posterPath,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (images.backdrops.length != 0)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BackdropDialog(
                              backdrops: images.backdrops,
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.backdrops.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  Constants.imagebaseUrl +
                                      images.backdrops[index].backdropPath,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ],
    );
  }

  Widget similarSeriesWidget(BuildContext context, Size size) {
    return ExpansionTile(
        key: similarExpansionTileKey,
        onExpansionChanged: (value) {
          if (value) {
            _scrollToSelectedContent(expansionTileKey: similarExpansionTileKey);
          }
        },
        title: Text(
          "Similar series",
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
        children: [
          FutureBuilder(
            future: similarSeries,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData && snapshot.data.totalResults > 0) {
                List<Data> series = snapshot.data.data;

                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    similarSerieWidget(size, series[0]),
                    similarSerieWidget(size, series[1]),
                    similarSerieWidget(size, series[2]),
                    similarSerieWidget(size, series[3]),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.done)
                return Center(
                  child: Text(
                    "None were found",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                );
              else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          ),
        ]);
  }

  Widget castWidget(Size size) {
    return FutureBuilder(
      future: serieCredit,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Credit credit = snapshot.data;
          List<CastMember> cast = credit.cast;

          return ExpansionTile(
            key: castExpansionTileKey,
            onExpansionChanged: (value) {
              if (value) {
                _scrollToSelectedContent(
                    expansionTileKey: castExpansionTileKey);
              }
            },
            title: Text(
              "Cast",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            children: [
              Container(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: cast.map((CastMember c) {
                    return Container(
                      height: 250,
                      margin: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: c.profilePath == null
                                ? NotFoundWidget()
                                : Image.network(
                                    Constants.imagebaseUrl + c.profilePath,
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                c.name,
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }

  Widget serieSeasons(Serie serie, BuildContext context, Size size) {
    return ExpansionTile(
      key: seasonsExpansionTileKey,
      onExpansionChanged: (value) {
        if (value) {
          _scrollToSelectedContent(expansionTileKey: seasonsExpansionTileKey);
        }
      },
      title: Text(
        "Seasons",
        style: Theme.of(context).textTheme.headline3,
        textAlign: TextAlign.center,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: serie.seasons.map((Season s) {
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SeasonDialog(season: s, title: serie.title);
                    },
                  );
                },
                child: Container(
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(
                        child: s.posterPath == null
                            ? NotFoundWidget()
                            : Image.network(
                                Constants.imagebaseUrl + s.posterPath,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          s.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget similarSerieWidget(Size size, Data serie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SerieScreen(
              serieID: serie.id,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        width: size.width / 2 - 40,
        height: 270,
        child: Column(
          children: [
            Container(
              height: 200,
              child: Image.network(
                imagebaseUrl + serie.posterPath,
                fit: BoxFit.fitWidth,
                loadingBuilder: (BuildContext context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.cumulativeBytesLoaded.toDouble() /
                          loadingProgress.expectedTotalBytes.toDouble(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                serie.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget serieOverview(BuildContext context, Serie serie) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Text(
        serie.overview,
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget serieInformations(BuildContext context, Serie serie) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Release date",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "${serie.releaseDate.year}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Language",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "${serie.originalLanguage.toUpperCase()}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Vote count",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "${serie.voteCount}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Vote average",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "${serie.voteAverage}",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (serie.numberSeasons != null)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Number of seasons",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "${serie.numberSeasons}",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
            if (serie.numberEpisodes != null)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Number of episodes",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "${serie.numberEpisodes}",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Status",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "${serie.status}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget serieTitle(BuildContext context, Serie serie) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Text(
        serie.title,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget seriePoster(Size size, Serie serie) {
    return Container(
      height: size.height * 0.6,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: (serie.posterPath != null || serie.backdropPath != null)
            ? Image.network(
                imagebaseUrl +
                    (serie.posterPath == null
                        ? serie.backdropPath
                        : serie.posterPath),
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                      child: Text(
                    "An error has occured",
                    style: TextStyle(color: Colors.red),
                  ));
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.cumulativeBytesLoaded.toDouble() /
                          loadingProgress.expectedTotalBytes.toDouble(),
                    ),
                  );
                },
              )
            : Icon(Icons.error),
      ),
    );
  }

  Widget serieCategories(List<Category> list) {
    List<Widget> widgetlist = [];

    for (Category i in list) {
      String categoryName = i.name;
      widgetlist.add(Container(
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 13, 8, 66),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          categoryName,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 5,
        spacing: 5,
        children: widgetlist,
      ),
    );
  }

  void _scrollToSelectedContent({GlobalKey expansionTileKey}) {
    final keyContext = expansionTileKey.currentContext;

    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 300)).then((value) {
        Scrollable.ensureVisible(
          keyContext,
        );
      });
    }
  }
}
