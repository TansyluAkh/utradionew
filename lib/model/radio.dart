import 'dart:convert';

import 'package:flutter/foundation.dart';

class MyRadio {
  final int id;
  final String blobid;
  final String idback;
  final int order;
  final String url;
  final String category;
  final String image;
  MyRadio({
    required this.blobid,
    required this.idback,
    required this.id,
    required this.order,
    required this.url,
    required this.category,
    required this.image,
  });

  factory MyRadio.fromMap(Map<String, dynamic> map) {
    return MyRadio(
      id: map['order'],
      order: map['order'],
      url: map['url'],
      category: map['category'],
      image: map['image'],
      blobid: map['id'],
      idback : map['idback']
    );
  }


  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MyRadio &&
        o.id == id &&
        o.order == order &&
        o.url == url &&
        o.category == category &&
        o.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        order.hashCode ^
        url.hashCode ^
        category.hashCode ^
        blobid.hashCode ^
        image.hashCode ^
        idback.hashCode ;
  }
}
