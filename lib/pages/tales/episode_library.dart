import 'package:flutter/material.dart';
import 'package:ut_radio/model/tales.dart';
import 'package:ut_radio/pages/shared/episode_card.dart';
import 'package:ut_radio/pages/shared/player_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ut_radio/pages/constants.dart';

class Episodes extends StatefulWidget {
  final name;
  const Episodes({Key? key, this.name}) : super(key: key);
  @override
  _EpisodesState createState() => _EpisodesState();
}

class _EpisodesState extends State<Episodes> {
  @override
  Widget build(BuildContext context) {
    print('Episodes here');
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: false,
          title: Text('URBANTATAR',
              style: const TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
              )).shimmer(primaryColor: red, secondaryColor: green),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          backgroundColor: Colors.transparent,
          // Colors.white.withOpacity(0.1),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: getTaleEpisodesData(widget.name),
                builder: (BuildContext context, AsyncSnapshot text) {
                  return text.data != null
                      ? ListView.builder(
                          itemCount: text.data != null ? text.data[0].length : 1,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            final episodeItem = text.data[0][index];
                            final playInfo = text.data[1];
                            return EpisodeCard(
                              header: episodeItem.author,
                              title: episodeItem.episodenum,
                              description: episodeItem.actor,
                              imageUrl: episodeItem.image,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayerScreen(
                                            link: episodeItem.social,
                                            playInfo: List.from(playInfo),
                                            index: index)));
                              },
                              onPlayTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayerScreen(
                                              link: episodeItem.social,
                                              playInfo: List.from(playInfo),
                                              index: index,
                                              autoPlay: true,
                                            )));
                              },
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: green,
                        ));
                })));
  }
}
