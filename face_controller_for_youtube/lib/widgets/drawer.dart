import 'package:face_controller_for_youtube/screens/home_page.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(0)));
                  });
                },
                child: Text(
                  'Face Swapping',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey[400],
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(1)));
                  });
                },
                child: Text(
                  'Face Mosaic',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Copyright © 2022 | FACE CONTROLLER',
                    style: TextStyle(
                      color: Colors.blueGrey[300],
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}