import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_clone/models/poster_model.dart';

import '../../constants/constants.dart';

class PosterDialog extends StatefulWidget {
  final List<Poster> posters;
  final int index;

  PosterDialog({this.posters, this.index});

  @override
  _PosterDialogState createState() => _PosterDialogState();
}

class _PosterDialogState extends State<PosterDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(children: [
        Swiper(
          loop: false,
          itemHeight: MediaQuery.of(context).size.height * 0.8,
          itemWidth: MediaQuery.of(context).size.height * 0.8,
          scrollDirection: Axis.horizontal,
          itemCount: widget.posters.length,
          pagination: FractionPaginationBuilder(),
          layout: SwiperLayout.DEFAULT,
          index: widget.index,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  Constants.imagebaseUrl + widget.posters[index].posterPath,
                  fit: BoxFit.fitHeight,
                ),
              ),
            );
          },
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
