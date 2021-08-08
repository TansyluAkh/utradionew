import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ut_radio/pages/episodescard.dart';
class Episode {
  final String episodenum;
  final String episode;
  final String audio;
  final String image;
  final String date;
  final String series;
  final String description;
  Episode({Key? key, required this.episodenum, required this.episode, required this.audio, required this.image, required this.date, required this.description, required this.series,  required this.series});

}


Future<List<CardGrid>> getEpisodesData(name) async {
  CollectionReference podcasts = FirebaseFirestore.instance.collection(name);
  List<CardGrid> arr = [];
  QuerySnapshot querySnapshot = await podcasts.get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var value = data!['image'].toString();
    Episode episodeItem = Episode(audio:data['audio'].toString(),
      episodenum: data['episodenum'].toString(),
      episode: data['episode'].toString(),
      image: data['image'].toString(),
      date: data['date'].toString(), series: data['name'].toString(), description: data['description'].toString(),)
    arr.add(CardGrid(episodeItem: episodeItem));
    print(value);});
  return arr;
}
