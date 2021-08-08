import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ut_radio/pages/episodescard.dart';
import 'package:ut_radio/pages/seriescard.dart';
import '/pages/constants.dart';
import '/model/series.dart';
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
            child:  FutureBuilder(
              future: getSeriesData(),
                    initialData: [Center(child:CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: green,
                    ))],
                    builder: (BuildContext context, AsyncSnapshot text) {
                      return GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      shrinkWrap: true,
                          physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,crossAxisCount: 2,
                      ),
                      itemCount: text!.data.length,
                      itemBuilder: (BuildContext ctx, index) {
                      return text!.data[index];
                      });})));
}}
