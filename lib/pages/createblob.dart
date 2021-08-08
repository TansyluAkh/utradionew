import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';

class ClipPage extends StatefulWidget {
  final width;
  final height;
  final url;
  final greencolor;
  final redcolor;
  const ClipPage({Key? key, this.redcolor, this.greencolor, this.width, this.height, this.url}) : super(key: key);
  @override
  _ClipPageState createState() => _ClipPageState();
}
  class _ClipPageState extends State<ClipPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
             Blob.fromID(
                id: ['9-7-3291'],
                size: widget.width*0.95,
                styles: BlobStyles(
                  gradient: LinearGradient(begin: Alignment.bottomRight, end: Alignment.bottomLeft,
                      colors: [widget.greencolor, widget.redcolor])
                      .createShader(Rect.fromLTRB(0, 0, 300, 300)),
                ),
              ),
            Container(
              // color: Colors.red,
              width: widget.width*0.9,
              child: ClipPath(
                clipper: BlobClipper(id: '20-6-416'),
                child: Image.network(
                  widget.url, alignment: Alignment.center,
                  height: widget.height*0.9, width: widget.width, fit: BoxFit.fill,
                ),
              ),
            ),
          ],);

  }
}
Widget buildrandom(BuildContext context, icon, height){
  return  Blob.random(
      styles: BlobStyles(
      color: Colors.white,
      fillType: BlobFillType.fill,
      gradient: LinearGradient(
      colors: [Color(0xFF507251), Colors.white])
      .createShader(Rect.fromLTRB(0, 0, 300, 300)),
  strokeWidth: 3,
  ),
  size: height * 0.08,
  edgesCount: 6,
  minGrowth: 7,
  child: icon);}
