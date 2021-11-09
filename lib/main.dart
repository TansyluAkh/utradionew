import 'package:flutter/services.dart';
import 'package:ut_radio/pages/constants.dart';
import 'package:ut_radio/pages/home_page.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    SplashApp(
      key: UniqueKey(),
      onInitializationComplete: () => runMainApp(),
    ),
  );
}

void runMainApp() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Montserrat"),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class SplashApp extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashApp({
    required Key key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashAppState createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  bool _hasError = false;
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      );
      setState(() {
        _initialized = true;
        print('INITIALIZED');
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_hasError) {
      return Scaffold(
          backgroundColor: white,
          body: Center(
            child: ElevatedButton(
              child: Text('retry'),
              onPressed: () => main(),
            ),
          ));
    }
    if (_initialized) {
      widget.onInitializationComplete();
    }
    return Scaffold(
        backgroundColor: white,
        body: Center(
          child: CircularProgressIndicator(),
        ));
  }
}
