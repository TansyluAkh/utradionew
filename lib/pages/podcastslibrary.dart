import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/pages/colors.dart';
import '/pages/recommendedcard.dart';
import '/model/song.dart';
import 'package:velocity_x/velocity_x.dart';
import 'PodcastPlayer.dart';

class Library extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25.0),
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Good Morning,\n",
                            style: kTitleStyle,
                          ),
                          TextSpan(
                            text: "Veranda",
                            style: kSubtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 26.0,
                      backgroundImage: NetworkImage(
                          "https://s6.gifyu.com/images/microphone.png"),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18.0),
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: white,
              ),
              child: TextField(
                cursorColor: green,
                decoration: InputDecoration(
                  hintText: "Search for podcasts...",
                  hintStyle: kHintTextStyle,
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    FontAwesomeIcons.search,
                    color: green,
                    size: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Text(
                    "Recommended",
                    style: kCategoryTitleStyle,
                  ),
                  Spacer(),
                  Text(
                    "View all",
                    style: kCategorySubtitleStyle,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Container(
              width: double.infinity,
              height: 265.0,
              margin: EdgeInsets.only(left: 18.0),
              child: ListView.builder(
                itemCount: recommendedList.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var recommend = recommendedList[index];
                  return RecommendedCard(podcast: recommend);
                },
              ),
            ),
            SizedBox(height: 25.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Text("Latest Playlist", style: kCategoryTitleStyle),
                  Spacer(),
                  Text("View all", style: kCategorySubtitleStyle),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            ListView.builder(
              itemCount: latestList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                var latest = latestList[index];
                return InkWell(
                  onTap: (){ Navigator.push(
                    context,
                    MaterialPageRoute(
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
                    ),
                    ));
              },
            ),
          ],
        ),
      ),
    ));
  }
}
