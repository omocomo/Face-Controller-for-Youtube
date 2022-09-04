import 'package:face_controller_for_youtube/widgets/responsive.dart';
import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String title;
  final String subtitle;

  const Heading({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.06,
        left: ResponsiveWidget.isSmallScreen(context)
        ? screenSize.width / 15
        : screenSize.width / 5,
        right: ResponsiveWidget.isSmallScreen(context)
        ? screenSize.width / 15
        : screenSize.width / 5,
      ),
      child: ResponsiveWidget.isSmallScreen(context)
      ? Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.end,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          SizedBox(height: 10),
        ],
      )
      : Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(),
          Text(
            title,
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.end,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}