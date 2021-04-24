import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies_clone/models/backdrop_model.dart';

import '../../constants/constants.dart';

class BackdropDialog extends StatefulWidget {
  final List<Backdrop> backdrops;

  BackdropDialog({this.backdrops});

  @override
  _BackdropDialogState createState() => _BackdropDialogState();
}

class _BackdropDialogState extends State<BackdropDialog> {
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
          itemCount: widget.backdrops.length,
          pagination: FractionPaginationBuilder(),
          layout: SwiperLayout.DEFAULT,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  Constants.imagebaseUrl + widget.backdrops[index].backdropPath,
                  fit: BoxFit.fitWidth,
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
