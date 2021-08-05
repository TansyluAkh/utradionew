import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '/pages/colors.dart';
import '/model/song.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'PodcastPlayer.dart';
class EpisodesCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: false,
          titleSpacing: 0.0,
          title: Text('URBANTATAR',
              style: const TextStyle(
                fontSize: 20,
              )).shimmer(primaryColor: red, secondaryColor: green),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          backgroundColor: Colors.transparent,
          // Colors.white.withOpacity(0.1),
          elevation: 0,
        ),
    body:
      SingleChildScrollView(
          child:
          ListView.builder(
          itemCount: latestList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
          var latest = latestList[index];
          return InkWell(
          onTap: (){ Navigator.push(context, MaterialPageRoute(
          builder: (context) => PodcastScreen(image: latest.image, description: latest.title, audio: latest.audio)));},
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
                      image: NetworkImage(latest.image),
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
                            latest.genre,
                            style: kFabStyle.copyWith(color: green),
                          ),
                        ),
                        Spacer(),
                        Text(
                          latest.title,
                          overflow: TextOverflow.ellipsis,
                          style: kTitleStyle,
                        ),
                        Spacer(),
                        Text(
                          "By ${latest.artist}",
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
                    child: Icon(
                      FontAwesomeIcons.play,
                      color: green,
                      size: 10.0,
                    ),
                  ),
                )
              ],
            ),
          ),));})));}}