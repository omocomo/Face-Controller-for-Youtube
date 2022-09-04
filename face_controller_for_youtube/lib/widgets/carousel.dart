import 'package:carousel_slider/carousel_slider.dart';
import 'package:face_controller_for_youtube/routes/requests.dart';
import 'package:face_controller_for_youtube/widgets/responsive.dart';
import 'package:flutter/material.dart';

class DestinationCarousel extends StatefulWidget {
  final List images;
  final Function(int) selectValueCallback;
  final int initSelectValue;
  const DestinationCarousel({
    Key? key, 
    required this.images,
    required this.selectValueCallback,
    this.initSelectValue = 0,
  }) : super(key: key);
  
  @override
  _DestinationCarouselState createState() => _DestinationCarouselState();

}

class _DestinationCarouselState extends State<DestinationCarousel> {
  final CarouselController _controller = CarouselController();

  // List _isSelected = [true, false, false, false, false, false, false];

  late int _current;

  // final List<String> images = [
  //   'assets/image/00003.png',
  //   'assets/image/00043.png',
  //   'assets/image/00059.png',
  //   'assets/image/00064.png',
  //   'assets/image/00128.png',
  //   'assets/image/00131.png',
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _current = widget.initSelectValue;

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     await getGivenImage().then((value) => setState(() => widget.images = value));
    // });

    // getGivenImage().then((value) => setState(() => widget.images = value));
  }

  final List<String> places = [
    '　　1　　',
    '　　2　　',
    '　　3　　',
    '　　4　　',
    '　　5　　',
    '　　6　　',
  ];

  List<Widget> generateImageTiles(screenSize) {
    // getGivenImage().then((value) => setState(() => images = value));
    // print(images);
    return widget.images
        .map(
          (element) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          'http://$server:8000/DATA/given/$element',
          width: ResponsiveWidget.isLargeScreen(context)
              ? 1200 / 1.5 / 2
              : screenSize.width / 1.5 / 2,
          height: ResponsiveWidget.isLargeScreen(context)
              ? 1200 / 1.5 / 2 / 1.5
              : screenSize.width / 1.5 / 2 / 1.5,
          // fit: BoxFit.cover,
        ),
      ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var imageSliders = generateImageTiles(screenSize);

    return Center(
      child: Container(
        width: ResponsiveWidget.isLargeScreen(context)
            ? 1200 / 1.5 / 2
            : screenSize.width / 1.5 / 2,
        height: ResponsiveWidget.isLargeScreen(context)
            ? 1200 / 1.5 / 2 / 1.5
            : screenSize.width / 1.5 / 2 / 1.5,
        // color: Colors.black12,
        child: CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              enlargeCenterPage: true,
              aspectRatio: 1 / 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                  // for (int i = 0; i < imageSliders.length; i++) {
                  //   if (i == index) {
                  //     _isSelected[i] = true;
                  //   } else {
                  //     _isSelected[i] = false;
                  //   }
                  // }
                });
                widget.selectValueCallback(_current);
              }
          ),
          carouselController: _controller,
        ),
      ),
    );
  }
}