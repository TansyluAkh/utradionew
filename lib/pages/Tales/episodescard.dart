import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ut_radio/pages/Tales/playerfunc.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardGrid extends StatelessWidget {
  final episodeItem;
  final playInfo;
  final index;
  CardGrid({required this.episodeItem, this.playInfo, this.index});

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Padding(
        padding: EdgeInsets.all(10.0),
    child: InkWell(
        onTap: (){ Navigator.push(context, MaterialPageRoute(
            builder: (context) => MyPlayer(episodeItem: episodeItem, playInfo: playInfo, index: index)));},
        child:Card(
          elevation: 6.0,
          shadowColor: green.withOpacity(.3),
          margin: EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 8.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: double.infinity,
            height: 120.0,
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: NetworkImage(episodeItem.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: green.withOpacity(.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            episodeItem.author,
                            style: kFabStyle.copyWith(color: green),
                          ),
                        ),
                        Spacer(),
                        Text(
                          episodeItem.episodenum,
                          overflow: TextOverflow.ellipsis,
                          style: kTitleStyle,
                        ),
                        Spacer(),
                        Text(episodeItem.actor,
                          overflow: TextOverflow.ellipsis,
                          style: kSubtitleStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundColor: green.withOpacity(.1),
                    child: IconButton(
                      color: green, onPressed: () {  }, icon: Icon(FontAwesomeIcons.play),
                    ),
                  ),
                )
              ],
            ),
          ),))
    ));
  }
}