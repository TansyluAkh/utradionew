import 'package:flutter/foundation.dart';

@immutable
class Song {
  Song({
    required this.type,
    required this.likes,
    required this.artist,
    required this.title,
    required this.streams,
    required this.url,
  });

  Song.fromJson(Map<String, Object?> json)
      : this(
    type: json['Type']! as String,
    likes: json['Likes']! as int,
    streams: json['Streams']! as int,
    url: json['Url']! as String,
    title: json['Title']! as String,
    artist: json['Artist']! as String,
  );

  final String type;
  final int likes;
  final String artist;
  final String title;
  final String url;
  final int streams;

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'likes': likes,
      'artist': artist,
      'title': title,
      'url': url,
      'streams': streams,
    };
  }
}