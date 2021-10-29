import 'package:flutter/services.dart';
import 'package:ut_radio/pages/my_flutter_app_icons.dart';
import 'package:ut_radio/model/radio.dart';
import 'package:radio_player/radio_player.dart';
import 'package:ut_radio/pages/home_blob.dart';
import 'package:ut_radio/pages/Podcasts/series_library.dart';
import 'package:ut_radio/pages/Tales/series_library.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Blob;
import 'package:blobs/blobs.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isplaying = false;
  RadioPlayer _audioPlayer = RadioPlayer();
  List<String>? metadata;
  String _category = 'Radio';
  String _ad = '';
  String _adlink = '';
  String _info0 = ' ';
  String _info = ' ';
  String _info1 = ' ';
  var _bottomNavIndex = 0;
  @override
  void initState() {
    super.initState();
    initRadioPlayer('');
  }

  void initRadioPlayer(selectedRadio) {
    _audioPlayer.setMediaItem('first', selectedRadio);
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
        getInfo(false);
      });
    });
  }

  Future<List<dynamic>> fetchRadios() async {
    List<MyRadio> radios = [];
    CollectionReference streams =
    FirebaseFirestore.instance.collection('streams');
    QuerySnapshot querySnapshot =
    await streams.orderBy('order', descending: false).get();
    final allData = querySnapshot.docs.forEach((element) {
      Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
      print(data!['text']);
      radios.add(MyRadio.fromMap(data!));
    }),
        selectedRadio = radios[0];
    return [radios, selectedRadio];
  }

  _playMusic(String url, radios, selectedRadio) {
    _audioPlayer.setMediaItem('first', url);
    _audioPlayer.play();
    getInfo(selectedRadio);
    selectedRadio = radios.firstWhere((element) => element.url == url);
    selectedRadio = radios.firstWhere((element) => element.url == url);
    print(selectedRadio.category);
    setState(() {});
  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference songs = FirebaseFirestore.instance.collection('songs');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Future<void>? _launched;
    Future<void> _launchInBrowser(String url) async {
      print(url);
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
        );
      } else {
        throw 'Could not launch $url';
      }
    }
    BlobController blobCtrl = BlobController();
    return  FutureBuilder(
        future: fetchRadios(),
        builder: (BuildContext context, AsyncSnapshot radiosInfo) {
          if (radiosInfo.data != null){
            var radios = radiosInfo.data[0];
            var selectedRadio = radiosInfo.data[1];
            return radiosInfo.data != null ?  Scaffold(
              backgroundColor: white,
          appBar: AppBar(
          backwardsCompatibility: false,
          centerTitle: false,
          systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text('URBANTATAR · ',
                style: const TextStyle(
                  fontSize: 20,
                )).shimmer(primaryColor: red, secondaryColor: green),
            Text(_category,
                style: const TextStyle(
                  fontSize: 18,
                )).shimmer(primaryColor: red, secondaryColor: green)
          ]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          backgroundColor: Colors.transparent,
          // Colors.white.withOpacity(0.1),
          elevation: 0,
        ),
        body: Column(children: [
          ConstrainedBox(
              constraints: BoxConstraints(maxHeight: height * 0.1),
              child: VxSwiper.builder(
                itemCount: 1,
                height: height * 0.1,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayAnimationDuration: 3.seconds,
                autoPlayCurve: Curves.easeInOut,
                enableInfiniteScroll: true,
                itemBuilder: (context, index) {
                  final s = _info + '\n' + _info1;
                  return Chip(
                    autofocus: true,
                    label: Container(
                      width: width,
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    backgroundColor: white,
                  );
                },
              )), SizedBox(height:20),
                  Align(alignment: Alignment.center,
                      child: radios.length > 0
                          ? VxSwiper.builder(
                          height: height*0.5,
                          itemCount: radios.length,
                          aspectRatio: 1.0,
                          enlargeCenterPage: true,
                          onPageChanged: (index) {
                            setState(() {
                              selectedRadio = radios[index];
                            _playMusic(selectedRadio.url, radios, selectedRadio);
                            });
                          },
                          itemBuilder: (context, index) {
                            final rad = radios[index];
                            print(rad);
                            return Column(children: [
                            HomeBlob(
                                url: rad.image,
                                width: width * 0.8,
                                height: width * 0.8,
                                redColor: red,
                                id: rad.blobid,
                                idback: rad.idback,
                                greenColor: green),
                              ]);
                          })
                          : Center(
                        child: CircularProgressIndicator(color: green),
                      )),
          _ad != '' ? Align(
              alignment: Alignment.center,
              child:  InkWell( child: Image.network(_ad, width: width/2, fit: BoxFit.contain), onTap: () => setState(() {
                _launched = _launchInBrowser(_adlink);
                print(_launched);
              }),)):SizedBox(height:1)
        ]),
        floatingActionButton: FloatingActionButton(
          mini: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            print('gg');
          },
          child: Icon(
            isplaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
            size: height * 0.05,
          ).onInkTap(() {
            if (isplaying) {
              _audioPlayer.pause();
            } else {
              if (selectedRadio != null) {
                _playMusic(selectedRadio.url, radios, selectedRadio);
              }
            }
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: green,
          splashRadius: 15,
          iconSize: height * 0.055,
          icons: [MyFlutterApp.podcast, MyFlutterApp.mom],
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 25,
          rightCornerRadius: 25,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
            navigateToPage(_bottomNavIndex);
          },
        )) : Center(
          child: CircularProgressIndicator(color: green,  backgroundColor: white),
          );
    }
          else{
            return Scaffold(
            backgroundColor: white,
                body: Center(
              child: CircularProgressIndicator(color: green),
            ));
          }});}

  void getInfo(selectedRadio) {
    setState(() {
      print(metadata);
      if (selectedRadio != false){
        print(selectedRadio.category);
        _category = selectedRadio.category;
        _ad = selectedRadio.text;
        _adlink = selectedRadio.adlink;}
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
    if (isplaying) {
      _audioPlayer.pause();
    }
    if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PodcastsLibrary()));
    }
    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TalesLibrary()));
    }
  }
}
