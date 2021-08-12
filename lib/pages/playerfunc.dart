import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ut_radio/pages/constants.dart';
import '/pages/createblob.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPlayer extends StatefulWidget {
  final episodeItem;
  final playInfo;
  final index;

  const MyPlayer({Key? key, this.playInfo, this.episodeItem, this.index})
      : super(key: key);

  @override
  _MyPlayerState createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playlist;
  int _addedCount = 0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _playlist = ConcatenatingAudioSource(children: widget.playInfo);
    _playlist.move(widget.index, 0);
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: false,
          titleSpacing: 0.0,
          title: Text('URBANTATAR',
              style: const TextStyle(
                fontSize: 20,
              )).shimmer(primaryColor: red, secondaryColor: green),

          backgroundColor: Colors.transparent,
          // Colors.white.withOpacity(0.1),
          elevation: 0,
        ),
        body: SafeArea(
          minimum: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) return SizedBox();
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 35),
                            child: ClipPage(
                              url: metadata.artUri.toString(),
                              height: height,
                              width: width,
                              redcolor: green,
                              greencolor: green,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                  backgroundColor: white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  minimumSize:
                                      Size(height * 0.035, width * 0.1)),
                              label: Text(' '+ metadata.album!,
                                  style: Theme.of(context).textTheme.headline6),
                              icon: Icon(FontAwesomeIcons.externalLinkAlt, size: height*0.035).shimmer(primaryColor: Color(0xff025724), secondaryColor:
                              Color(0xff7fc168)),
                              onPressed: () => setState(() {
                                _launched = _launchInBrowser(widget.episodeItem.social);
                                print(_launched);
                              }),)),
                          SizedBox(height: 20),
                          Text(metadata.title,
                              style: Theme.of(context).textTheme.subtitle1),
                          SizedBox(height: 10),
                        ]);
                  }),
              ControlButtons(_player),
              StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: (newPosition) {
                      _player.seek(newPosition);
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
            ],
          ),
        ));
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) =>
              IconButton(
                iconSize: height * 0.03,
                color: black.withOpacity(0.8),
                icon: Icon(FontAwesomeIcons.stepBackward),
                onPressed: player.hasPrevious ? player.seekToPrevious : null,
              ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: height * 0.05,
                height: height * 0.05,
                child: CircularProgressIndicator(color: black.withOpacity(0.8)),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(FontAwesomeIcons.play),
                iconSize: height * 0.05,
                color: black.withOpacity(0.8),
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(FontAwesomeIcons.pause),
                iconSize: height * 0.05,
                color: black.withOpacity(0.8),
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(FontAwesomeIcons.play),
                iconSize: height * 0.03,
                color: black.withOpacity(0.8),
                onPressed: () =>
                    player.seek(Duration.zero,
                        index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) =>
              IconButton(
                icon: Icon(FontAwesomeIcons.stepForward),
                iconSize: height * 0.03,
                color: black.withOpacity(0.8),
                onPressed: player.hasNext ? player.seekToNext : null,
              ),
        ),
      ],
    );
  }
}