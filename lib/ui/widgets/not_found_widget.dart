import 'package:flutter/material.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: (size.width - 100) / 2,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(
          color: Color.fromARGB(150, 13, 8, 66),
          spreadRadius: 0,
          blurRadius: 7,
          offset: Offset(0, 1),
        )
      ]),
      child: Icon(
        Icons.error,
        color: Colors.white,
      ),
    );
  }
}
