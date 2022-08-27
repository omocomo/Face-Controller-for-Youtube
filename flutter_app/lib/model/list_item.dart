import 'package:flutter/cupertino.dart';

class ListItem {
  final String imageName;
  final String urlImage;

  static int selectIndex = 0;
  // int selectIndex;

  const ListItem({
    required this.imageName,
    required this.urlImage,
    required int selectIndex,
  });

  set selectValue(int value) {
    selectIndex = value;
  }

  get getValue {
    return selectIndex;
  }
}