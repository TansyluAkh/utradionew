import '/model/radio.dart';
import 'package:radio_player/radio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Blob;
import 'package:blobs/blobs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _likedsong = 'start';
  RadioPlayer _audioPlayer = RadioPlayer();
  List<MyRadio>? radios;
  MyRadio? _selectedRadio;
  bool _isPlaying = false;
  bool _ispressed = false;
  List<String>? metadata;
  String _info0 = 'empty';
  String _info = ' ';
  String _info1 = ' ';
  String _doc = '0';

  @override
  void initState() {
    super.initState();
    fetchRadios();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _audioPlayer.stateStream.listen((value) {
      setState(() {
        _isPlaying = value;
      });
    });
    _audioPlayer.metadataStream.listen((value) {
      setState(() {
        if (value[2] != '') {
          metadata = value;
        } else {
          metadata = ['hello', 'hello', 'hello'];
        }
        print(metadata);
        getInfo();
      });
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList
        .fromJson(radioJson)
        .radios;
    _selectedRadio = radios![0];
    print(radios);
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.setMediaItem('first', url);
    _audioPlayer.play();
    _selectedRadio = radios!.firstWhere((element) => element.url == url);
    _selectedRadio = radios!.firstWhere((element) => element.url == url);
    print(_selectedRadio!.name);
    setState(() {});
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  IconData check() {
    if (_likedsong != _info1) {
      return CupertinoIcons.suit_heart;
    } else {
      return CupertinoIcons.suit_heart_fill;
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
    BlobController blobCtrl = BlobController();
    return Scaffold(
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: false,
            child: Column(children: [
              [
                Padding(
                    child: Text('URBANTATAR',
                        style: const TextStyle(
                          fontSize: 20,
                        )).shimmer(
                        primaryColor: Vx.red500, secondaryColor: Colors.green),
                    padding: EdgeInsets.only(top: 70)),
                VxSwiper.builder(
                  itemCount: 2,
                  height: 50.0,
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
                )
              ].vStack(alignment: MainAxisAlignment.start),
              30.heightBox,
              radios != null
                  ? VxSwiper.builder(
                itemCount: radios!.length,
                aspectRatio: 1.0,
                enlargeCenterPage: true,
                onPageChanged: (index) {
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

                  return VxBox(
                      child: ZStack(
                        [
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: VxBox(
                              child: rad.category.text.uppercase.white
                                  .make()
                                  .shimmer(
                                  primaryColor: Vx.red500,
                                  secondaryColor: Colors.green)
                                  .px16(),
                            )
                                .height(40)
                                .transparent
                                .alignCenter
                                .withRounded(value: 10.0)
                                .make(),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: VStack(
                              [
                                rad.name.text.xl3.white.bold.make(),
                                5.heightBox,
                                rad.tagline.text.sm.white.semiBold.make(),
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                            ),
                          )
                        ],
                      ))
                      .clip(Clip.antiAlias)
                      .bgImage(
                    DecorationImage(
                        image: NetworkImage(rad.image),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0),
                            BlendMode.darken)),
                  )
                      .border(
                    width: 5.0,
                  )
                      .withRounded(value: 60.0)
                      .make()
                      .p16();
                },
              ).centered()
                  : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child:
                      Blob.animatedRandom(
                      styles:  BlobStyles(
                      color:  Colors.green,
                      fillType:  BlobFillType.fill,
                      gradient: LinearGradient(colors:  _isPlaying
                      ? [Colors.redAccent, Colors.lightGreenAccent] : [Colors.blue, Colors.lightGreenAccent])
                          .createShader(Rect.fromLTRB(0, 0, 300, 300)),
                      strokeWidth:3,
                      ),
                      loop: true,
                      size: 150,
                      controller: blobCtrl,
                      child: Icon(
                        _isPlaying
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_arrow_solid,
                        size: 70.0,
                      )
                          .onInkTap(() {
                        if (_isPlaying) {
                          _audioPlayer.pause();
                        } else {
                          _playMusic(_selectedRadio!.url);
                        }
                      }),
                      ),

                  ))
            ])));
  }

  void getInfo() {
    setState(() {
      if (metadata?[1] != null) {
        _info = metadata?[1] ?? 'x';
      }
      if (metadata?[0] != null) {
        _info0 = metadata?[0] ?? 'x';
      }
      if (metadata?[2] != null) {
        _info1 = metadata?[2] ?? 'x';
      }
    });
    return;
  }
}
