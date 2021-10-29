import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';

class Episode {
  final String episodenum;
  final String id;
  final String idback;
  final String episode;
  final String audio;
  final String image;
  final String date;
  final String series;
  final String social;
  final String description;

  Episode(
      {Key? key,
      required this.social,
      required this.episodenum,
      required this.episode,
      required this.id,
      required this.idback,
      required this.audio,
      required this.image,
      required this.date,
      required this.description,
      required this.series});
}

Future<List<Object>> getEpisodesData(name) async {
  CollectionReference podcasts = FirebaseFirestore.instance.collection(name);
  CollectionReference blobs = FirebaseFirestore.instance.collection('blobs');
  var q = await blobs.doc('episodes').get();
  List<Object> arr = [];
  List<AudioSource> playlist = [];
  int _nextMediaId = 0;
  QuerySnapshot querySnapshot = await podcasts.orderBy('number', descending: true).get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var value = data!['image'].toString();
    var song = AudioSource.uri(Uri.parse(data['audio']),
        tag: MediaItem(
          id: '${_nextMediaId++}',
          album: data['episodenum'].toString(),
          title: data['episode'].toString(),
          artUri: Uri.parse(data['image'].toString()),
        ));
    playlist.add(song);
    Episode episodeItem = Episode(
      audio: data['audio'].toString(),
      episodenum: data['episodenum'].toString(),
      social: data['social'].toString(),
      episode: data['episode'].toString(),
      image: data['image'].toString(),
      date: data['date'].toString(),
      series: data['name'].toString(),
      id: q['id'],
      idback: q['idback'],
      description: data['description'].toString(),
    );
    arr.add(episodeItem);
    print(value);
  });
  return [arr, playlist];
}
