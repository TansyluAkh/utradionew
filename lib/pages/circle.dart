import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';

class CircleMenu extends StatefulWidget {

  //const CircleMenu({Key? key,  this.color, this.greencolor, this.width, this.height, this.url}) : super(key: key);
  @override
  _CircleMenuState createState() => _CircleMenuState();
}
  class _CircleMenuState extends State<CircleMenu> {
  @override
  Widget build(BuildContext context) {
    String _colorName = 'No';
    Color _color = Colors.black;
    return  CircularMenu(
      alignment: Alignment.bottomRight,
      backgroundWidget: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 28),
            children: <TextSpan>[
              TextSpan(
                text: _colorName,
                style:
                TextStyle(color: _color, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' button is clicked.'),
            ],
          ),
        ),
      ),
      toggleButtonColor: Colors.pink,
      items: [
        CircularMenuItem(
            icon: Icons.home,
            color: Colors.green,
            onTap: () {
              setState(() {
                _color = Colors.green;
                _colorName = 'Green';
              });
            }),
        CircularMenuItem(
            icon: Icons.search,
            color: Colors.blue,
            onTap: () {
              setState(() {
                _color = Colors.blue;
                _colorName = 'Blue';
              });
            }),
        CircularMenuItem(
            icon: Icons.settings,
            color: Colors.orange,
            onTap: () {
              setState(() {
                _color = Colors.orange;
                _colorName = 'Orange';
              });
            }),
        CircularMenuItem(
            icon: Icons.chat,
            color: Colors.purple,
            onTap: () {
              setState(() {
                _color = Colors.purple;
                _colorName = 'Purple';
              });
            }),
        CircularMenuItem(
            icon: Icons.notifications,
            color: Colors.brown,
            onTap: () {
              setState(() {
                _color = Colors.brown;
                _colorName = 'Brown';
              });
            })
      ],
    );}}