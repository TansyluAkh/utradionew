import 'package:flutter/material.dart';
import '/pages/colors.dart';
import '/model/song.dart';

class RecommendedCard extends StatelessWidget {
  final Podcast podcast;
  final height;
  final width;
  RecommendedCard({required this.podcast, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width*0.3,
      margin: EdgeInsets.only(right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Container(
              width: width*0.3,
              height: width*0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
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