import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_clone/api/api_manager.dart';
import 'package:movies_clone/models/categories_model.dart';
import 'package:movies_clone/models/data_model.dart';
import 'package:movies_clone/models/movies_model.dart';

class MovieScreen extends StatefulWidget {
  final int movieID;

  MovieScreen({@required this.movieID});

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final String imagebaseUrl = "https://image.tmdb.org/t/p/w500";

  Future<Movie> movie;
  Future<DataModel> similarMovies;

  Future<void> _getData() async {
    setState(() {
      movie = API_Manager().getMovieDetail(widget.movieID);
      similarMovies = API_Manager().getSimilarMovies(widget.movieID);
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
          "Movie detail",
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: movie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Movie movie = snapshot.data;
            return Container(
              width: size.width,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    moviePoster(size, movie),
                    SizedBox(height: 20),
                    movieTitle(context, movie),
                    SizedBox(height: 20),
                    movieInformations(context, movie),
                    SizedBox(height: 20),
                    Container(
                        child: Text("Overview",
                            style: Theme.of(context).textTheme.headline3)),
                    SizedBox(height: 10),
                    movieOverview(context, movie),
                    SizedBox(height: 20),
                    movieCategories(movie.genreIds),
                    SizedBox(height: 20),
                    Container(
                        child: Text("Similar movies",
                            style: Theme.of(context).textTheme.headline3)),
                    SizedBox(height: 10),
                    FutureBuilder(
                      future: similarMovies,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data.totalResults > 0) {
                          List<Data> movies = snapshot.data.data;

                          return Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              similarMovie(size, movies[0]),
                              similarMovie(size, movies[1]),
                              similarMovie(size, movies[2]),
                              similarMovie(size, movies[3]),
                            ],
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done)
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
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else
            return Center(
              child: Text("heyy"),
            );
        },
      ),
    );
  }

  GestureDetector similarMovie(Size size, Data movie) {
    return GestureDetector(
      onTap: () {
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieScreen(
              movie: movie,
              categoriesList: widget.categoriesList,
            ),
            fullscreenDialog: true,
          ),
        );*/
      },
      child: Container(
        width: size.width / 2 - 40,
        height: 270,
        child: Column(
          children: [
            Container(
              height: 200,
              child: Image.network(
                imagebaseUrl + movie.posterPath,
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
                movie.title,
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

  Text movieOverview(BuildContext context, Movie movie) {
    return Text(
      movie.overview,
      style: Theme.of(context).textTheme.bodyText2,
      textAlign: TextAlign.center,
    );
  }

  Column movieInformations(BuildContext context, Movie movie) {
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
                    "${movie.releaseDate.year}",
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
                    "${movie.originalLanguage.toUpperCase()}",
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
                    "${movie.voteCount}",
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
                    "${movie.voteAverage}",
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
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Budget",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "${movie.budget}",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Status",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "${movie.status}",
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

  Container movieTitle(BuildContext context, Movie movie) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        movie.title,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  Container moviePoster(Size size, Movie movie) {
    return Container(
      height: size.height * 0.6,
      width: size.width * 0.6,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          imagebaseUrl + movie.posterPath,
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
        ),
      ),
    );
  }

  Widget movieCategories(List<Category> list) {
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

    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 5,
      spacing: 5,
      children: widgetlist,
    );
  }
}
