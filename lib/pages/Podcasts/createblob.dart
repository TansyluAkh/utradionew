import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClipPage extends StatefulWidget {
  final width;
  final height;
  final url;
  final greencolor;
  final redcolor;

  const ClipPage(
      {Key? key,
      this.redcolor,
      this.greencolor,
      this.width,
      this.height,
      this.url})
      : super(key: key);

  @override
  _ClipPageState createState() => _ClipPageState();
}

class _ClipPageState extends State<ClipPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
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
            decoration:  BoxDecoration( color: widget.greencolor.withOpacity(0.3),borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
      Align( alignment: Alignment.center, child: Image.network(widget.url, width: widget.width*0.6, fit: BoxFit.fill, alignment: Alignment.center)),
    ]);
  }
}

Widget buildrandom(BuildContext context, icon, height) {
  return Blob.random(
      styles: BlobStyles(
        color: Colors.white,
        fillType: BlobFillType.fill,
        gradient: LinearGradient(colors: [Color(0xFF507251), Colors.white])
            .createShader(Rect.fromLTRB(0, 0, 300, 300)),
        strokeWidth: 3,
      ),
      size: height * 0.08,
      edgesCount: 6,
      minGrowth: 7,
      child: icon);
}
