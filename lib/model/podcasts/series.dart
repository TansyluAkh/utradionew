import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ut_radio/pages/shared/series_card.dart';

Future<List<SeriesCard>> getPodcastSeriesWidget() async {
  CollectionReference Series = FirebaseFirestore.instance.collection('series');
  List<SeriesCard> arr = [];
  QuerySnapshot querySnapshot = await Series.get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var value = data!['image'].toString();
    arr.add(SeriesCard(
      title: data['name'].toString(),
      image: data['image'].toString(),
      episodeName: data['name'].toString(),
    ));
    print(value);
  });
  return arr;
}
