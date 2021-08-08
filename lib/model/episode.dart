import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:ut_radio/pages/episodescard.dart';
import 'package:just_audio/just_audio.dart';
class Episode {
  final String episodenum;
  final String episode;
  final String audio;
  final String image;
  final String date;
  final String series;
  final String description;
  Episode({Key? key, required this.episodenum, required this.episode, required this.audio, required this.image, required this.date, required this.description, required this.series});

}


Future<List<Object>> getEpisodesData(name) async {
  CollectionReference podcasts = FirebaseFirestore.instance.collection(name);
  List<Object> arr = [];
  List<AudioSource> playlist = [];
  int _nextMediaId = 0;
  QuerySnapshot querySnapshot = await podcasts.get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var value = data!['image'].toString();
    var song = AudioSource.uri(
        Uri.parse(
            data['audio']),
        tag: MediaItem(
          id: '${_nextMediaId++}',
          album: data['episodenum'],
          title: data['episode'],
          artUri: Uri.parse(
              data['image']),
        ));
    playlist.add(song);
    Episode episodeItem = Episode(audio:data['audio'].toString(),
      episodenum: data['episodenum'].toString(),
      episode: data['episode'].toString(),
      image: data['image'].toString(),
      date: data['date'].toString(), series: data['name'].toString(), description: data['description'].toString(),);
    arr.add(episodeItem);
    print(value);});
  return [arr, playlist];
}
var songInit = AudioSource.uri(
Uri.parse(
'https://urban.tatar/podcast/kazan_kayniy/kazan_kayniy_1.mp3'),
tag: MediaItem(
id: '${0}',
album: '',
title: '',
artUri: Uri.parse(
'https://s6.gifyu.com/images/loadut.jpg'),
));
Episode episodeInit = Episode(audio:'',
  episodenum: '',
  episode: '',
  image: 'https://s6.gifyu.com/images/loadut.jpg',
  date: '', series: '', description: '');

var initData = [[episodeInit, episodeInit], songInit];
