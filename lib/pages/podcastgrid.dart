import 'package:flutter/material.dart';
import '/pages/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'PodcastPlayer.dart';

class CardGrid extends StatelessWidget {
  final String audio;
  final String description;
  final String image;
  final String title;
  CardGrid({required this.description, required this.title, required this.image,required this.audio});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){ Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PodcastScreen(image: image, description: description, audio: audio)));},
        child: Container(
          width: double.infinity,
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(image),
                fit: BoxFit.cover),

            borderRadius: BorderRadius.all(Radius.circular(10)),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(title, style: kTitleStyle),
              ),
              Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.star),
                            SizedBox(width: 10,),
                            Text(description, style: TextStyle(fontSize: 15,color: Colors.white),),
                          ],
                        )),
                  )),

            ],
          ),
        ),
      ),
    );
  }
}