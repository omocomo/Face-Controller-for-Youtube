import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:face_controller_for_youtube/widgets/bottom_bar.dart';
import 'package:face_controller_for_youtube/widgets/contents.dart';
import 'package:face_controller_for_youtube/widgets/drawer.dart';
import 'package:face_controller_for_youtube/widgets/responsive.dart';
import 'package:face_controller_for_youtube/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int index;
  HomePage(this.index);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    List<Widget> bodyWidgets = [ChangeContents(), MosaicContents()];

    // 현재 화면 크기
    var screenSize = MediaQuery.of(context).size;

    // 스크롤 위치에 따른 AppBar 투명도
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      // 테마 두 개 있음 (light, dark)
      backgroundColor: Theme.of(context).backgroundColor,

      // appBar 위젯 뒤 body 존재 여부
      extendBodyBehindAppBar: true,

      // 화면 사이즈에 따라 appBar 동적 변화
      // small screen: width < 800
      // large screen: width > 1200
      appBar: ResponsiveWidget.isSmallScreen(context)
        // 작은 화면일 경우 AppBar
        ? AppBar(
          backgroundColor:
          Theme.of(context).bottomAppBarColor.withOpacity(_opacity),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                EasyDynamicTheme.of(context).changeTheme();
              },
            ),
          ],
          title: Text(
            'FACE CONTROLLER',
            style: TextStyle(
              color: Colors.blueGrey[100],
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
            ),
          ),
        )
        // 큰 화면일 경우 AppBar = TopBarContents
        : PreferredSize(
          preferredSize: Size(screenSize.width, 1000),
          child: TopBarContents(_opacity),
        ),

      // 작은 화면일 때 좌측 상단 햄버거 버튼 누르면 왼쪽에서 나오는 내비게이션 위젯
      drawer: LeftDrawer(),

      // 커버 이미지, contents, bottom bar
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: SizedBox(
                height: screenSize.height * 0.45,
                width: screenSize.width,
                child: Image.asset(
                  'assets/image/cover.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            bodyWidgets[index],
            BottomBar(),
          ],
        ),
      ),
    );
  }
}