import 'package:flutter/material.dart';
import '/pages/colors.dart';
import '/model/song.dart';

class RecommendedCard extends StatelessWidget {
  final Podcast podcast;
  RecommendedCard({required this.podcast});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      margin: EdgeInsets.only(right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 8.0,
            shadowColor: black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                image: DecorationImage(
                  image: NetworkImage(podcast.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Spacer(),
          Text(
            podcast.title,
            overflow: TextOverflow.ellipsis,
            style: kTitleStyle,
          ),
          SizedBox(height: 5.0),
          Text(podcast.artist, style: kSubtitleStyle)
        ],
      ),
    );
  }
}