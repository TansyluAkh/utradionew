import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ut_radio/model/tales.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:ut_radio/pages/shared/series_card.dart';
import 'package:velocity_x/velocity_x.dart';

import 'episode_library.dart';

class TalesLibrary extends StatelessWidget {
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
        body: new SingleChildScrollView(
            child: FutureBuilder(
                future: getTaleSeries(),
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
                          itemCount: text.data.length,
                          itemBuilder: (BuildContext ctx, index) {
                            final data = text.data[index];
                            return SeriesCard(
                                title: data.title,
                                image: data.imageUrl,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Episodes(name: data.collection)));
                                });
                          })
                      : Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: green,
                        ));
                })));
  }
}
