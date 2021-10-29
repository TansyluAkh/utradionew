import 'package:flutter/material.dart';
import 'package:ut_radio/pages/Podcasts/episodescard.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:ut_radio/model/Podcasts/episode.dart';

class Episodes extends StatefulWidget {
  final name;
  const Episodes({Key? key, this.name}) : super(key: key);
  @override
  _EpisodesState createState() => _EpisodesState();
}
class _EpisodesState extends State<Episodes> {
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
    body:
      SingleChildScrollView(
          child:  FutureBuilder(
          future: getPodcastEpisodesData(widget.name),
          builder: (BuildContext context, AsyncSnapshot text) {
    return text.data != null ?
          ListView.builder(
          itemCount:  text.data != null ? text.data[0].length : 1,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
          return CardGrid(episodeItem:text.data[0][index], playInfo: text.data[1], index: index);}
          ):Center(child:CircularProgressIndicator(
      backgroundColor: Colors.white,
      color: green,
    ));})))
    ;}}