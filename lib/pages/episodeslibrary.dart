import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '/pages/constants.dart';
import '/model/episode.dart';

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
          child:  FutureBuilder(
          future: getEpisodesData(widget.name),
          initialData: [Center(child:CircularProgressIndicator(
          backgroundColor: Colors.white,
    color: green,
    )),],
          builder: (BuildContext context, AsyncSnapshot text) {
    return
          ListView.builder(
          itemCount: text!.data.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
          return text!.data[index];}
          );})));}}