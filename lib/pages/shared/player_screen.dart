import 'dart:ui';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:ut_radio/pages/shared/seek_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerScreen extends StatefulWidget {
  final String link;
  final List<AudioSource> playInfo;
  final int index;
  final bool autoPlay;

  const PlayerScreen(
      {Key? key,
      required this.playInfo,
      required this.link,
      required this.index,
      this.autoPlay = false})
      : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playlist;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _playlist = ConcatenatingAudioSource(children: widget.playInfo.sublist(widget.index));
    _init().whenComplete(() {
      if (widget.autoPlay) _player.play();
    });
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e, stackTrace) {
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
          (position, bufferedPosition, duration) =>
              PositionData(position, bufferedPosition, duration ?? Duration.zero));

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
            color: Colors.black,
          ),
          centerTitle: false,
          titleSpacing: 0.0,
          title: Text('URBANTATAR',
              style: const TextStyle(
                fontSize: 20,
              )).shimmer(primaryColor: red, secondaryColor: green),
          backgroundColor: Colors.transparent,
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
                            child: PlayerImage(
                              url: metadata.artUri.toString(),
                              width: width,
                              greenColor: green,
                            ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                    backgroundColor: white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(25))),
                                    minimumSize: Size(height * 0.03, width * 0.1)),
                                label: Text(' ' + metadata.album!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: darkgreen, fontSize: 18)),
                                icon: Icon(FontAwesomeIcons.externalLinkAlt,
                                    size: height * 0.03, color: darkgreen),
                                onPressed: () => setState(() {
                                  _launched = _launchInBrowser(widget.link);
                                  print(_launched);
                                }),
                              )),
                          SizedBox(height: 20),
                          Container(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Text(metadata.title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.subtitle1),
                              ),
                            ),
                          ),
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
                    bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
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

class PlayerImage extends StatefulWidget {
  final double width;
  final String url;
  final Color greenColor;

  const PlayerImage({Key? key, required this.greenColor, required this.width, required this.url})
      : super(key: key);

  @override
  _PlayerImageState createState() => _PlayerImageState();
}

class _PlayerImageState extends State<PlayerImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(widget.url),
              fit: BoxFit.cover,
            )),
        width: widget.width * 0.8,
        height: widget.width * 0.8,
        alignment: Alignment.center,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
                color: widget.greenColor.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      Align(
          alignment: Alignment.center,
          child: Image.network(widget.url,
              width: widget.width * 0.6, fit: BoxFit.fill, alignment: Alignment.center)),
    ]);
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
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
                onPressed: () => player.seek(Duration.zero, index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
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

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
