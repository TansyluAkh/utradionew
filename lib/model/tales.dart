import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';

class TaleEpisode {
  final String episodenum;
  final String id;
  final String idback;
  final String audio;
  final String image;
  final String author;
  final String actor;
  final String social;

  TaleEpisode(
      {Key? key,
      required this.social,
      required this.episodenum,
      required this.actor,
      required this.id,
      required this.idback,
      required this.author,
      required this.audio,
      required this.image});
}

class TaleSeries {
  final String title;
  final String imageUrl;
  final String collection;

  TaleSeries({required this.title, required this.imageUrl, required this.collection});
}

Future<List<Object>> getTaleEpisodesData(name) async {
  CollectionReference podcasts = FirebaseFirestore.instance.collection(name);
  CollectionReference blobs = FirebaseFirestore.instance.collection('blobs');
  var q = await blobs.doc('tales').get();
  List<Object> arr = [];
  List<AudioSource> playlist = [];
  int _nextMediaId = 0;
  QuerySnapshot querySnapshot = await podcasts.orderBy('name', descending: false).get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var song = AudioSource.uri(Uri.parse(data!['audio']),
        tag: MediaItem(
          id: '${_nextMediaId++}',
          album: data!['author'].toString(),
          title: data!['name'].toString(),
          artist: data!['actor'].toString(),
          artUri: Uri.parse(data!['image'].toString()),
        ));
    playlist.add(song);
    TaleEpisode episodeItem = TaleEpisode(
        audio: data!['audio'].toString(),
        episodenum: data!['name'].toString(),
        social: data!['social'].toString(),
        image: data!['image'].toString(),
        actor: data!['actor'].toString(),
        author: data!['author'].toString(),
        id: q['id'],
        idback: q['idback']);
    arr.add(episodeItem);
  });
  return [arr, playlist];
}

Future<List<TaleSeries>> getTaleSeries() async {
  CollectionReference series = FirebaseFirestore.instance.collection('booksandsongs');
  QuerySnapshot querySnapshot = await series.get();

  final result = querySnapshot.docs.map((element) {
    Map<String, dynamic> data = element.data() as Map<String, dynamic>;
    return TaleSeries(
      collection: data['collection'].toString(),
      title: data['name'].toString(),
      imageUrl: data['image'].toString(),
    );
  });

  return result.toList();
}
