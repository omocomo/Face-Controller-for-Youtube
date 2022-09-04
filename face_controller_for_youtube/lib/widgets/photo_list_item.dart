import 'package:face_controller_for_youtube/model/photo_item.dart';
import 'package:face_controller_for_youtube/widgets/responsive.dart';
import 'package:flutter/material.dart';

class PhotoListItemWidget extends StatelessWidget {

  final PhotoListItem item;
  final Animation<double> animation;
  final VoidCallback? onClicked;

  const PhotoListItemWidget({
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