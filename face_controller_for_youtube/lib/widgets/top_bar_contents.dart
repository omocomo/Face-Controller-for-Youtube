import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:face_controller_for_youtube/screens/home_page.dart';
import 'package:flutter/material.dart';

class TopBarContents extends StatefulWidget {
  final double opacity;

  TopBarContents(this.opacity);

  @override
  _TopBarContentsState createState() => _TopBarContentsState();
}

class _TopBarContentsState extends State<TopBarContents> {
  final List _isHovering = [false, false];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        color: Theme.of(context).bottomAppBarColor.withOpacity(widget.opacity),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'FACE CONTROLLER',
                style: TextStyle(
                  color: Colors.blueGrey[100],
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: screenSize.width / 8),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                          ? _isHovering[0] = true
                          : _isHovering[0] = false;
                        });
                      },
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(0)));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '얼굴바꾸기',
                            style: TextStyle(
                              color: _isHovering[0]
                              ? Colors.blue[200]
                              : Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[0],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: screenSize.width / 20),
                    InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                          ? _isHovering[1] = true
                          : _isHovering[1] = false;
                        });
                      },
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(1)));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '모자이크',
                            style: TextStyle(
                              color: _isHovering[1]
                              ? Colors.blue[200]
                              : Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[1],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.brightness_6),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.white,
                onPressed: () {
                  EasyDynamicTheme.of(context).changeTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}