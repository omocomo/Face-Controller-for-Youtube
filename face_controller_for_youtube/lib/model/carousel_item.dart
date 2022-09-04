class CarouselListItem {
  final String imageName;
  final String urlImage;
  int selectIndex = 0;

  CarouselListItem({
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