import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/pages/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'PodcastPlayer.dart';

class CardGrid extends StatelessWidget {
  final String audio;
  final String description;
  final String image;
  final String title;
  final String date;
  final String series;
  CardGrid({required this.description,
    required this.title,
    required this.image,
    required this.audio, required this.date, required this.series});

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Padding(
        padding: EdgeInsets.all(10.0),
    child: Card(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    clipBehavior: Clip.antiAlias,
    child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:[
    Image.network(image,fit: BoxFit.fitHeight, alignment: Alignment.bottomLeft,),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
          Expanded(
              child: Text(series)
          )]
    ),
    ),
    ));
  }
}