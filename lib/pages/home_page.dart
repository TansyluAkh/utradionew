import '/model/radio.dart';
import 'package:radio_player/radio_player.dart';
import '/pages/homeblob.dart';
import '/pages/serieslibrary.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Blob;
import 'package:blobs/blobs.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  bool isplaying = false;
  bool _ispressed = false;
  String _likedsong = 'start';
  RadioPlayer _audioPlayer = RadioPlayer();
  List radios = [];
  MyRadio? _selectedRadio;
  List<String>? metadata;
  String _info0 = 'empty';
  String _info = ' ';
  String _info1 = ' ';
  String _doc = '0';

  int _page = 0;

  var _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchRadios();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _audioPlayer.setMediaItem('first', 'https://ilgamsharipov.radioca.st/stream');
    _audioPlayer.play();
    _audioPlayer.stateStream.listen((value) {
      setState(() {
        isplaying = value;
      });
    });
    _audioPlayer.metadataStream.listen((value) {
      setState(() {
        if (value[2] != '') {
          metadata = value;
        } else {
          metadata = [' ', ' ', ' '];
        }
        print(metadata);
        getInfo();
      });
    });
  }

  fetchRadios() async {
    CollectionReference  streams = FirebaseFirestore.instance.collection('streams');
    QuerySnapshot querySnapshot = await streams.orderBy('order', descending: false).get();
    final allData = querySnapshot.docs.forEach((element) {
      Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
      print(data);
      radios.add(MyRadio.fromMap(data!));}),
    _selectedRadio = radios![0];
    print(radios);
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.setMediaItem('first', url);
    _audioPlayer.play();
    _selectedRadio = radios!.firstWhere((element) => element.url == url);
    _selectedRadio = radios!.firstWhere((element) => element.url == url);
    print(_selectedRadio!.category);
    setState(() {});
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  IconData check() {
    if (_likedsong != _info1) {
      return FontAwesomeIcons.heart;
    } else {
      return FontAwesomeIcons.heart;
    }
  }

  String getLikes(docId) {
    if (docId.length < 1) {
      docId = _info0;
      getLikes(docId);
    }
    songs.doc(docId).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        setState(() {
          _doc = documentSnapshot.get('Likes').toString();
          print(_doc);
        });
      } else {
        var type = _selectedRadio?.category ?? "not stated";
        getInfo();
        songs
            .doc(docId)
            .set({
          'Artist': _info, // John Doe
          'Type': type, // Stokes and Sons
          'Title': _info1, // 42
          'Likes': 0,
          'Streams': 1,
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
    return _doc;
  }

  Future<void> addSong() async {
    print(_likedsong);
    getInfo();
    print('LIKED');
    if (_likedsong != _info1) {
      setState(() {
        _likedsong = _info1;
        _ispressed = true;
      });
      return songs
          .doc(_info1)
          .update(<String, dynamic>{
        'Likes': FieldValue.increment(1),
      })
          .then((value) => print("Song info Added"))
          .catchError((error) => print("Failed to add song info: $error"));
    } else {
      getLikes(_likedsong);
      print('hello');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    BlobController blobCtrl = BlobController();
    return Scaffold(
        appBar: AppBar(
          title: Text('URBANTATAR',
              style: const TextStyle(
                fontSize: 20,
              )).shimmer(primaryColor: red, secondaryColor: green),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          backgroundColor: Colors.transparent,
          // Colors.white.withOpacity(0.1),
          elevation: 0,
        ),
        body: Stack(children: [
          SizedBox(
            height: height*0.1,
            width: width,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.1),
              child: VxSwiper.builder(
                itemCount: 2,
                height: height * 0.1,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayAnimationDuration: 5.seconds,
                autoPlayCurve: Curves.linear,
                enableInfiniteScroll: true,
                itemBuilder: (context, index) {
                  final s = [_info, _info1][index];
                  return Chip(
                    autofocus: true,
                    label: Text(s,
                        style: const TextStyle(
                          fontSize: 20,
                        )),
                    backgroundColor: Colors.transparent,
                  );
                },
              )),
          Align(
          alignment: Alignment.center,
          child:
          radios.length>0 ? VxSwiper.builder(
              height: width * 0.9,
              itemCount: radios!.length,
              aspectRatio: 1.0,
              enlargeCenterPage: true,
              onPageChanged: (index) {
                blobCtrl.change();
                _selectedRadio = radios![index];
                _audioPlayer.pause();
                _playMusic(_selectedRadio!.url);
                songs.doc(_info1).update(<String, dynamic>{
                  'Streams': FieldValue.increment(1),
                });
                getInfo();
                getLikes(_info1);
                setState(() {});
              },
              itemBuilder: (context, index) {
                final rad = radios![index];
                print(rad);
                return ClipPage(
                    url: rad.image,
                    width: width * 0.9,
                    height: width * 0.9,
                    redcolor: red,
                    id: rad.blobid,
                    idback: rad.idback,
                    greencolor: green);
              })
           :
          Center(
            child: CircularProgressIndicator(color:green),
          ))
          ,
          ]),
        floatingActionButton:
        FloatingActionButton(
          mini:true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () { print('gg'); },
            child:
            Icon(isplaying
                  ? FontAwesomeIcons.pause
                  : FontAwesomeIcons.play,
                size: height * 0.05,
              ).onInkTap(() {
                if (isplaying) {
                  _audioPlayer.pause();
                } else {
                  if (_selectedRadio != null) {
                    _playMusic(_selectedRadio!.url);
                  }
                }}),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar:
        AnimatedBottomNavigationBar(
          icons:
          [FontAwesomeIcons.microphone,
            FontAwesomeIcons.child],
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index){
            setState(() {
              _bottomNavIndex = index;
            });
            navigateToPage(_bottomNavIndex);
          },

        )


    );
  }

  void getInfo() {
    setState(() {
      print(metadata);
      //
      if (metadata?[1] != null) {
        _info = metadata?[1].split("[")[0] ?? 'x';
      }
      if (metadata?[0] != null) {
        _info0 = metadata?[0].split("[")[0] ?? 'x';
      }
      if (metadata?[2] != null) {
        _info1 = metadata?[2].split("[")[0] ?? 'x';
      }
    });
    return;
  }

  void navigateToPage(index) {
    if (isplaying){
      _audioPlayer.pause();}
    if (index == 0){
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => Library()));}
  }
}
