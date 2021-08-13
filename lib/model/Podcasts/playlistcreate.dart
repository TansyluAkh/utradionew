import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';


Future<List<AudioSource>> getPlayListData(name) async {
  CollectionReference podcasts = FirebaseFirestore.instance.collection(name);
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
    print(value);});
  return playlist;
}
