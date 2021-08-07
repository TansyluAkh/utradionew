import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ut_radio/pages/podcastgrid.dart';
class Podcast {
  final String title;
  final String artist;
  final String image;
  final String date;
  final String audio;
  Podcast({required this.audio, required this.title, required this.artist, required this.image, required this.date});
}


Future<List<CardGrid>> getData() async {
  CollectionReference podcasts = FirebaseFirestore.instance.collection('podcasts');
  List<CardGrid> arr = [];
  QuerySnapshot querySnapshot = await podcasts.get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var value = data!['image'].toString();
    arr.add(CardGrid(audio:data['audio'].toString(),
        description: data['description'].toString(),
        title: data['episode'].toString(),
        image: data['image'].toString(),
        date: data['date'].toString(), series: data['name'].toString(),));
    print(value);});
  return arr;
}

List<Podcast> recommendedList = [
  Podcast(
    audio: "https://urban.tatar/podcast/kazan_kayniy/kazan_kayniy_36.mp3",
      title: "The Comedy Podcast",
      artist: "Jessica Veranda",
      image: "https://s6.gifyu.com/images/poiE7KBZYuM.jpg",
      date: "Comedy"),
  Podcast(
    audio: "https://urban.tatar/podcast/kazan_kayniy/kazan_kayniy_36.mp3",
      title: "Try your lucky for your life",
      artist: "Andrea jhon",
      image: "https://s6.gifyu.com/images/poiE7KBZYuM.jpg",
      date: "Business"),
  Podcast(
    audio: "https://urban.tatar/podcast/kazan_kayniy/kazan_kayniy_36.mp3",
      title: "Tips and Trick how to be a UI/UX Designer",
      artist: "Dicky Reynaldi",
      image: "https://s6.gifyu.com/images/poiE7KBZYuM.jpg",
      date: "Designer"),
  Podcast(
    audio: "https://urban.tatar/podcast/kazan_kayniy/kazan_kayniy_36.mp3",
      title: "Just be nice for you life and keep going up",
      artist: "Dedy Corbuzier",
      image: "https://s6.gifyu.com/images/poiE7KBZYuM.jpg",
      date: "Story"),
  Podcast(
    audio: "https://urban.tatar/podcast/kazan_kayniy/kazan_kayniy_36.mp3",
      title: "Heal your mind",
      artist: "Gilang W.P",
      image: "https://s6.gifyu.com/images/poiE7KBZYuM.jpg",
      date: "Psycholgy"),
];
