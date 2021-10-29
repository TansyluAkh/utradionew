import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';

class HomeBlob extends StatefulWidget {
  final width;
  final height;
  final url;
  final greenColor;
  final redColor;
  final id;
  final idback;
  const HomeBlob(
      {Key? key,
      this.redColor,
      this.greenColor,
      this.width,
      this.height,
      this.url,
      this.id,
      this.idback})
      : super(key: key);
  @override
  _HomeBlobState createState() => _HomeBlobState();
}

class _HomeBlobState extends State<HomeBlob> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Blob.fromID(
          id: [widget.idback],
          size: widget.width,
          styles: BlobStyles(
            gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.bottomLeft,
                    colors: [widget.greenColor, widget.redColor])
                .createShader(Rect.fromLTRB(0, 0, 300, 300)),
          ),
        ),
        Container(
          // color: Colors.red,
          width: widget.width * 0.95,
          child: ClipPath(
            clipper: BlobClipper(id: widget.id),
            child: Image.network(
              widget.url,
              alignment: Alignment.center,
              height: widget.height,
              width: widget.width,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
