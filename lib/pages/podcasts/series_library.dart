import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:ut_radio/model/Podcasts/series.dart';
import 'package:velocity_x/velocity_x.dart';

class PodcastsLibrary extends StatelessWidget {
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
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: getPodcastSeriesWidget(),
                builder: (BuildContext context, AsyncSnapshot text) {
                  return text.data != null
                      ? GridView.builder(
                          padding: EdgeInsets.all(10.0),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                          ),
                          itemCount: text!.data.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return text!.data[index];
                          })
                      : Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: green,
                        ));
                })));
  }
}
