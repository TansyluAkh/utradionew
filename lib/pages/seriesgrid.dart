import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SeriesGrid extends StatelessWidget {

  final String image;
  final String title;
  SeriesGrid({required this.title,
    required this.image,});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      clipBehavior: Clip.antiAlias,
      child:
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:[
            Image.network(image,fit: BoxFit.contain, alignment: Alignment.bottomLeft,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            Expanded(
                child: Text(title)
            )]
      ),
    );
  }
}