import 'package:flutter/material.dart';
import 'package:movies_clone/models/season_model.dart';

class SeasonDialog extends StatefulWidget {
  final Season season;
  final String title;

  SeasonDialog({this.season, @required this.title});

  @override
  _SeasonDialogState createState() => _SeasonDialogState();
}

class _SeasonDialogState extends State<SeasonDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                alignment: Alignment.center,
                child: Text(
                  "${widget.title}",
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "Season",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                "${widget.season.seasonNumber}",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10),
              Text(
                "Number of episodes",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                "${widget.season.numberEpisodes}",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10),
              Text(
                "Overview",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "${widget.season.overview}",
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
