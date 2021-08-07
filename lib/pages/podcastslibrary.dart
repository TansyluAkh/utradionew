import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ut_radio/pages/podcastgrid.dart';
import '/pages/colors.dart';

import '/pages/recommendedcard.dart';
import '/model/song.dart';
import 'package:velocity_x/velocity_x.dart';

class Library extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - kToolbarHeight - 24;
    final double itemHeight = height/ 2;
    final double itemWidth = width / 3;
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
        body: new SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
              future: getData(),
                    initialData: CardGrid( audio: "https://urban.tatar/podcast/kazan_kayniy/kazan_kayniy_36.mp3",
            title: "The Comedy Podcast",
            description: "Jessica Veranda",
            image: "https://s6.gifyu.com/images/poiE7KBZYuM.jpg",
            date: "Comedy", series: 'who',) ,
                    builder: (BuildContext context, AsyncSnapshot text) {
                      return ListView(children:text.data!,);})
    )],

    )));
  }
}
