import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ut_radio/pages/Tales/seriescard.dart';

Future<List<SeriesGrid>> getSeriesData() async {
  CollectionReference Series = FirebaseFirestore.instance.collection('booksandsongs');
  List<SeriesGrid> arr = [];
  QuerySnapshot querySnapshot = await Series.get();
  final allData = querySnapshot.docs.forEach((element) {
    Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
    var value = data!['image'].toString();
    arr.add(SeriesGrid(
      collection: data['collection'].toString(),
      title: data['name'].toString(),
      image: data['image'].toString(),
    ));
    print(value);
  });
  return arr;
}
