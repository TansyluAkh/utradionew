import 'package:flutter/material.dart';
import '/pages/constants.dart';
import '/model/episode.dart';

class RecommendedCard extends StatelessWidget {
  final Episode episodeItem;
  final height;
  final width;
  RecommendedCard({required this.episodeItem, this.width, this.height});
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
                  image: NetworkImage(episodeItem.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Spacer(),
          Text(
            episodeItem.episodenum,
            overflow: TextOverflow.ellipsis,
            style: kTitleStyle,
          ),
          SizedBox(height: 5.0),
          Text(episodeItem.series, style: kSubtitleStyle)
        ],
      ),
    );
  }
}