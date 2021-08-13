import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:ut_radio/pages/Tales/episodeslibrary.dart';

class SeriesGrid extends StatelessWidget {
  final String collection;
  final String image;
  final String title;
  SeriesGrid({required this.title, required this.collection,
    required this.image,});

  @override
  Widget build(BuildContext context) {

    return GridTile(
        child: Padding(
        padding: EdgeInsets.all(10.0),
    child: InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(
    builder: (context) => Episodes(name:collection)));},
    child: Stack(
      children:[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
         child: Image.network(image),),
        Positioned(
          bottom: 10,
          left: 3,
          child:Chip(
            label: Text(title),
            backgroundColor: white,
            labelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            elevation: 7,
            shadowColor: Colors.black.withOpacity(0.7),
            ),
          )
      ],
    ))));
  }
}