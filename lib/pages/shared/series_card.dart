import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ut_radio/pages/constants.dart';

class SeriesCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  SeriesCard({required this.title, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
                onTap: onTap,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(image),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 3,
                      child: Chip(
                        label: Text(title),
                        backgroundColor: white,
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        elevation: 7,
                        shadowColor: Colors.black.withOpacity(0.7),
                      ),
                    )
                  ],
                ))));
  }
}
