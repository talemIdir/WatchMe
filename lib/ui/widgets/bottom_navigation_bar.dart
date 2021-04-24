import 'package:flutter/material.dart';

class BottomNabBar extends StatefulWidget {
  @override
  _BottomNabBarState createState() => _BottomNabBarState();
}

class _BottomNabBarState extends State<BottomNabBar> {
  int _currentIndex = 0;

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      //Navigator.pushReplacement(context, )
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => changeTab(0),
                  child: Container(
                    alignment: Alignment.center,
                    color: _currentIndex == 0
                        ? Color.fromARGB(150, 13, 8, 66)
                        : Theme.of(context).primaryColor,
                    height: 70,
                    child: Text("Home"),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => changeTab(1),
                  child: Container(
                    height: 70,
                    color: _currentIndex == 1
                        ? Color.fromARGB(150, 13, 8, 66)
                        : Theme.of(context).primaryColor,
                    alignment: Alignment.center,
                    child: Text("TV"),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => changeTab(2),
                  child: Container(
                    height: 70,
                    color: _currentIndex == 2
                        ? Color.fromARGB(150, 13, 8, 66)
                        : Theme.of(context).primaryColor,
                    alignment: Alignment.center,
                    child: Text("BROWSE"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
