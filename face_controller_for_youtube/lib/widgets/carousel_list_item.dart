import 'package:carousel_slider/carousel_slider.dart';
import 'package:face_controller_for_youtube/model/carousel_item.dart';
import 'package:face_controller_for_youtube/widgets/carousel.dart';
import 'package:face_controller_for_youtube/widgets/responsive.dart';
import 'package:flutter/material.dart';

class CarouselListItemWidget extends StatelessWidget {

  final CarouselListItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;
  final List images;

  const CarouselListItemWidget({
    required this.images,
    required this.item,
    required this.animation,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizeTransition(
    key: ValueKey(item.urlImage),
    sizeFactor: animation,
    child: buildItem(context),
  );

  Widget buildItem(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
        height: ResponsiveWidget.isLargeScreen(context)
                    ? 1200 / 1.5 / 2 / 1.5 + 20
                    : screenSize.width / 1.5 / 2 / 1.5 + 20,
        // margin: EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(12),
        //   color: Colors.blue,
        // ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // child: 
                width: ResponsiveWidget.isLargeScreen(context)
                    ? 1200 / 1.5 / 2
                    : screenSize.width / 1.5 / 2,
                height: ResponsiveWidget.isLargeScreen(context)
                    ? 1200 / 1.5 / 2 / 1.5
                    : screenSize.width / 1.5 / 2 / 1.5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(item.urlImage),
                    fit: BoxFit.cover),
                ),
              ),
              DestinationCarousel(
                images: images,
                selectValueCallback: (v) {item.selectValue = v;},
                initSelectValue: 0,
              ),
              IconButton(
                onPressed: onClicked,
                icon: Icon(
                  Icons.remove_circle,
                ),
              ),
            ],
          )
    );
  }
}