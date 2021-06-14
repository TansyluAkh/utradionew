import 'package:ai_radio/model/radio.dart';
import 'package:ai_radio/utils/ai_util.dart';
import 'package:radio_player/radio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RadioPlayer _audioPlayer = RadioPlayer();
  List<MyRadio> ?radios;
  MyRadio ?_selectedRadio;
  Color _selectedColor = Colors.white;
  bool _isPlaying = false;
  List<String>? metadata;
  @override
  void initState() {
    super.initState();
    fetchRadios();
    initRadioPlayer();
  }
  void initRadioPlayer() {
    _audioPlayer.setMediaItem('vinyl', 'https://ilgamsharipov.radioca.st/stream');
    _audioPlayer.stateStream.listen((value) {
      setState(() {
        _isPlaying = value;
      });
    });

    _audioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
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
    _selectedRadio = radios!.firstWhere((element) => element!.url == url);
    print(_selectedRadio!.name);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: _selectedColor,
          // ignore: unnecessary_null_comparison
            child: radios != null
            ? [
            100.heightBox,
            "All Channels".text.xl.white.semiBold.make().px16(),
            20.heightBox,
            ListView(
              padding: Vx.m0,
              shrinkWrap: true,
              children:[ListTile(title: Text('Безнен турында'),
                leading: Icon(IconData(57521, fontFamily: 'MaterialIcons')), onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));}),
                ListTile(title: Text('Безнен турында'), leading: Icon(IconData(57521, fontFamily: 'MaterialIcons'))),
                ListTile(title: Text('Безнен турында'), leading: Icon(IconData(57521, fontFamily: 'MaterialIcons'))),
                ListTile(title: Text('Безнен турында'), leading: Icon(IconData(57521, fontFamily: 'MaterialIcons'))),
                ListTile(title: Text('Безнен турында'), leading: Icon(IconData(57521, fontFamily: 'MaterialIcons')))]
            ).expand()
            ].vStack(crossAlignment: CrossAxisAlignment.start)
              : const Offstage(),
        ),
      ),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight).withGradient(
    LinearGradient(
    colors: [
    AIColors.primaryColor2,
    _selectedColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    )
        // .bgImage(DecorationImage(image: AssetImage('assets/bg.jpg')))
              .make(),
          [
            AppBar(
              title: "UT Radio".text.xl4.bold.white.make().shimmer(
                  primaryColor: Vx.purple300, secondaryColor: Colors.white),
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
                            child:
                                rad.category.text.uppercase.white.make().px16(),
                          )
                              .height(40)
                              .black
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
                        )],
                      //   Align(
                      //       alignment: Alignment.center,
                      //       child: [
                      //         Icon(
                      //           CupertinoIcons.play_circle,
                      //           color: Colors.white,
                      //         ),
                      //         10.heightBox,
                      //         "Ике тапкыр бас".text.gray300.make(),
                      //       ].vStack())
                      // ],
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
                        .border(color: Colors.black, width: 5.0)
                        .withRounded(value: 25.0)
                        .make()
                        .onInkDoubleTap(() {
                      _playMusic(rad!.url);
                    }).p16();
                  },
                ).centered()
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Уйный - ${metadata?[1]}"
                    .text
                    .white
                    .makeCentered(),
              Icon(
                _isPlaying
                    ? CupertinoIcons.stop_circle
                    : CupertinoIcons.play_circle,
                color: Colors.white,
                size: 50.0,
              ).onInkTap(() {
                if (_isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _playMusic(_selectedRadio!.url!);
                }
              })
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: VStack(
        [[
            " - Introduction".text.gray500.widest.sm.make(),
            10.heightBox,
            "@googledevexpert for Flutter, Firebase, Dart & Web.\nPublic Speaker, Blogger, Entrepreneur & YouTuber.\nFounder of MTechViral."
                .text
                .white
                .xl3
                .maxLines(5)
                .make()
                .w(context.isMobile
                ? context.screenWidth
                : context.percentWidth * 40),
            20.heightBox,
          ].vStack(),
          RaisedButton(
            onPressed: () {
              //
            },
            hoverColor: Vx.purple700,
            shape: Vx.roundedSm,
            color: Colors.deepPurpleAccent,
            textColor: Colors.black,
            child: "Visit mtechviral.com".text.make(),
          ).h(50)
        ],
        crossAlignment: CrossAxisAlignment.center,
        alignment: MainAxisAlignment.center,
      )
    );
  }
}

