import '/model/radio.dart';
import '/model/song.dart';
import 'package:radio_player/radio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _likedsong = 'start';
  RadioPlayer _audioPlayer = RadioPlayer();
  List<MyRadio>? radios;
  MyRadio? _selectedRadio;
  Color _selectedColor = Colors.white;
  bool _isPlaying = false;
  List<String>? metadata;
  bool _ispressed = false;
  String _info = '';
  String _info1 = '';
  int _likednum = 0;
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
        metadata = value;
        print(metadata);
      });
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios![0];
    _selectedColor = Color(int.tryParse(_selectedRadio!.color)!);
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
  Icon check(){
    if (_likedsong != metadata?[2]){
      return Icon(Icons.local_fire_department_outlined);
    }
    else{
      return Icon(Icons.local_fire_department_sharp);
    }
  }
  String getLikes(docId){
    songs.doc(docId).snapshots().listen((event) {
      setState(() {
        _likednum = event.get("Likes");
        print(_likednum.toString()+ ' LIKESNUM');
      });
    });
    return _likednum.toString();
  }

  Future<void> addSong() async {

    print(_likedsong );
    print('LIKED');
    if (_likedsong != metadata?[2]){
      setState(() {
        _likedsong = metadata?[2] ?? 'hello';
          _ispressed = true;});
      return songs.doc(_likedsong)
          .update(<String, dynamic>{
        'Likes': FieldValue.increment(1),
      })
          .then((value) => print("Song info Added"))
          .catchError((error) => print("Failed to add song info: $error"));}
    else{ print('hello');}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Container(
            color: _selectedColor,
            // ignore: unnecessary_null_comparison
            child: radios != null
                ?
                  ].vStack(crossAlignment: CrossAxisAlignment.start)
                : const Offstage(),
          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: false,
            child: Column(children: [
              [
                AppBar(
                  title: "UT radio".text.xl4.bold.white.make().shimmer(
                      primaryColor: Vx.red500, secondaryColor: Colors.green),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  centerTitle: true,
                ).h(100.0).p16(),
              ].vStack(alignment: MainAxisAlignment.start),
              30.heightBox,
              radios != null
                  ? VxSwiper.builder(
                      itemCount: radios!.length,
                      aspectRatio: 1.0,
                      enlargeCenterPage: true,
                      onPageChanged: (index) {
                        _selectedRadio = radios![index];
                        final colorHex = radios![index].color;
                        _selectedColor = Color(int.tryParse(colorHex)!);
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
                            .make().p16();
                      },
                    ).centered()
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                Align(
                alignment: Alignment.bottomCenter,

                child: [Text(getInfo(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  [Icon(
                    _isPlaying
                    ? CupertinoIcons.stop_circle
                        : CupertinoIcons.play_circle,
                    size: 50.0,
                    ).shimmer(primaryColor: Vx.red500, secondaryColor: Colors.green).onInkTap(() {
                    if (_isPlaying) {
                    _audioPlayer.pause();
                    } else {
                    _playMusic(_selectedRadio!.url);
                    }}),
                  IconButton(
                    icon: check(),
                    color: _ispressed? Colors.redAccent : Colors.grey,
                    iconSize: 50,
                    onPressed: addSong,
                    ),
                    Text(getLikes('0'),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50,),
                    ),
                 ].hStack(),].vStack()
              ).pOnly(bottom: context.percentHeight * 1),
            ])));
  }

   String getInfo() {
     setState(() {
       if (metadata?[0] != null){
       _info = metadata?[0] ?? '';}
       if (metadata?[1] != null){
         _info1 = metadata?[0] ?? '';
     }});
     return _info+'\n'+_info1;
   }

}

