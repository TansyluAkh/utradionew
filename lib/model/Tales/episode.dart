import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';
class Episode {
  final String episodenum;
  final String id;
  final String idback;
  final String audio;
  final String image;
  final String author;
  final String actor;
  final String social;
  Episode({Key? key, required this.social, required this.episodenum,  required this.actor, required this.id, required this.idback,required this.author,  required this.audio, required this.image});

}


Future<List<Object>> getEpisodesData(name) async {
  CollectionReference podcasts = FirebaseFirestore.instance.collection(name);
  CollectionReference blobs = FirebaseFirestore.instance.collection('blobs');
  var q = await blobs.doc('tales').get();
  List<Object> arr = [];
  List<AudioSource> playlist = [];
  int _nextMediaId = 0;
  QuerySnapshot querySnapshot = await podcasts.orderBy('name', descending: false).get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var song = AudioSource.uri(
        Uri.parse(
            data!['audio']),
        tag: MediaItem(
          id: '${_nextMediaId++}',
          album: data!['author'].toString(),
          title: data!['name'].toString(),
          artist: data!['actor'].toString(),
          artUri: Uri.parse(
              data!['image'].toString()),
        ));
    playlist.add(song);
    Episode episodeItem = Episode(audio:data!['audio'].toString(),
      episodenum: data!['name'].toString(),
      social: data!['social'].toString(),
      image: data!['image'].toString(),
      actor: data!['actor'].toString(), author: data!['author'].toString(), id: q['id'], idback: q['idback'] );
    arr.add(episodeItem);});
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
  image: '', id: '9-7-3291', idback:'9-7-3291', social: '', author: '', actor: '');

var initData = [[episodeInit], songInit];
