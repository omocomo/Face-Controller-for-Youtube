import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/widget/list_item_widget.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/widget/button_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app/chewie_list_item.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'data/list_items.dart';
import 'model/list_item.dart';
import 'package:flutter_app/data/list_items.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Face Controller for Youtube';

  Container MultiImages(String imagePath, String heading, String subHeading){
    return Container(
      width: 160.0,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Image.network(imagePath),
            ListTile(
              title: Text(heading),
              subtitle: Text(subHeading),
            )
          ],
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.green),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  // File? file;
  var video_name = 'No File Selected';
  var image_name = 'No File Selected';
  var image_file;
  List select_image_list = List.generate(1, (index) => null);
  bool _upload_visibility = false;
  bool _select_visibility = false;
  bool _result_visibility = false;
  bool _mode1_visibility = false;
  bool _mode2_visibility = false;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "upload") {
        _upload_visibility = visibility;
      }
      if (field == "select") {
        _select_visibility = visibility;
      }
      if (field == "result") {
        _result_visibility = visibility;
      }
      if (field == "mode1") {
        _mode1_visibility = visibility;
      }
      if (field == "mode2") {
        _mode2_visibility = visibility;
      }
    });
  }

  int _current_img = 0;
  // List given_img_list = [];

  final listKey = GlobalKey<AnimatedListState>();
  final List<ListItem> items = List.from(listItems);

  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {
        video_name = 'No File Selected';
        image_name = 'No File Selected';
        image_file;
        select_image_list = List.generate(1, (index) => null);
        _upload_visibility = false;
        _select_visibility = false;
        _result_visibility = false;
        _mode1_visibility = false;
        _mode2_visibility = false;
      });
    });
  }

  @override
 void dispose() {
   _controller.dispose();
   super.dispose();
 }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    height: 99,
                  ),
                  Text(MyApp.title),
                ],
              ),
              bottom: TabBar(
                controller: _controller,
                tabs: [
                  Tab(
                    text: "Face Swapping",
                  ),
                  Tab(
                    text: "Mosaic",
                  ),
                ],
              ),
              centerTitle: true,
            ),
            resizeToAvoidBottomInset: false,
            body: new TabBarView(
              controller: _controller,
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(32),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonWidget(
                            text: 'Upload Video',
                            icon: Icons.cloud_upload_outlined,
                            onClicked: uploadVideo,
                          ),
                          SizedBox(height: 8),
                          Text(
                            video_name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                              visible: _upload_visibility,
                              child: SizedBox(
                                height: 300,
                                child: ChewieListItem(
                                  videoPlayerController:
                                      VideoPlayerController.asset(
                                    'http://localhost:8000/DATA/videos/$video_name',
                                  ),
                                  looping: true,
                                ),
                              )),
                          SizedBox(height: 48),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 350,
                                  height: 40,
                                  child:
                                    ButtonWidget(
                                      text: 'Mode1: Change Specific',
                                      icon: Icons.numbers,
                                      onClicked: selectMode1,
                                    ),
                                ),
                                SizedBox(width: 10,),
                                SizedBox(
                                  width: 310,
                                  height: 40,
                                  child:
                                    ButtonWidget(
                                      text: 'Mode2: Change All',
                                      icon: Icons.numbers,
                                      onClicked: selectMode2,
                                    ),
                                ),
                              ]
                          ),
                          SizedBox(height: 48),
                          Visibility(
                            visible: _mode2_visibility,
                            child: Column(
                              children: [
                                SizedBox(height: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CarouselSlider(
                                      items: 
                                        given_img_list.map((imgName) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: 200, //MediaQuery.of(context).size.width,
                                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                child: Image.network(
                                                  'http://localhost:8000/DATA/given/$imgName', fit: BoxFit.fitHeight), 
                                              );
                                            },
                                          );
                                        }).toList(),
                                      options: CarouselOptions(
                                        height: 200.0,
                                        initialPage: 0,
                                        onPageChanged: (index, e) {
                                          setState(() {
                                            _current_img = index;
                                          });
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 48),
                                ButtonWidget(
                                  text: 'Select This Image',
                                  icon: Icons.mms_outlined,
                                  onClicked: selectGivenImage,
                                ), 
                                SizedBox(height: 8),
                                // Text(
                                //   image_name,
                                //   style: TextStyle(
                                //       fontSize: 16, fontWeight: FontWeight.w500),
                                //  ),
                                SizedBox(height: 20),
                                Visibility(
                                  visible: _select_visibility,
                                  child: SizedBox(
                                    height: 250,
                                    child: Image.network(
                                      'http://localhost:8000/DATA/images/$image_name',
                                    ),
                                  )),
                              ],
                            )
                          ),

                          Visibility(
                            visible: _mode1_visibility,
                            child: Column(
                              children: [
                                ButtonWidget(
                                  text: 'Select Images',
                                  icon: Icons.mms_outlined,
                                  onClicked: insertItem,
                                ), SizedBox(height: 8),
                                // Text(
                                //   image_name,
                                //   style: TextStyle(
                                //       fontSize: 16, fontWeight: FontWeight.w500),
                                //  ),
                                SizedBox(height: 20),
                                Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  child: AnimatedList(
                                    key: listKey,
                                    initialItemCount: items.length,
                                    itemBuilder: ((context, index, animation) => ListItemWidget(
                                      item: items[index],
                                      animation: animation,
                                      onClicked: () => removeItem(index),
                                    )),
                                ),),
                                Visibility(
                                  visible: _select_visibility,
                                  child: SizedBox(
                                    height: 250,
                                    child: Image.network(
                                      'http://localhost:8000/DATA/images/$image_name',
                                    ),
                                  )),
                              ],
                            )
                          ),

                          SizedBox(height: 48),
                          ButtonWidget(
                            text: 'Convert',
                            icon: Icons.published_with_changes_rounded,
                            onClicked: specificSwapping,
                          ),
                          SizedBox(height: 20),
                          Visibility(
                              visible: _result_visibility,
                              child: SizedBox(
                                height: 300,
                                child: ChewieListItem(
                                  videoPlayerController:
                                      VideoPlayerController.asset(
                                    // 'assets/output.mp4'
                                    'http://localhost:8000/DATA/outputs/$video_name',
                                  ),
                                  looping: true,
                                ),
                              )),
                          // task != null ? buildUploadStatus(task!) : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(32),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonWidget(
                              text: 'Upload Video',
                              icon: Icons.cloud_upload_outlined,
                              onClicked: uploadVideo,
                            ),
                            SizedBox(height: 8),
                            Text(
                              video_name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 20),
                            Visibility(
                                visible: _upload_visibility,
                                child: SizedBox(
                                  height: 300,
                                  child: ChewieListItem(
                                    videoPlayerController:
                                        VideoPlayerController.asset(
                                      'http://localhost:8000/DATA/videos/$video_name',
                                    ),
                                    looping: true,
                                  ),
                                )),
                            SizedBox(height: 48),
                            ButtonWidget(
                                text: 'Select Images',
                                icon: Icons.mms_outlined,
                                onClicked: selectImages,
                              ), 
                              SizedBox(height: 8),
                              // Text(
                              //   image_name,
                              //   style: TextStyle(
                              //       fontSize: 16, fontWeight: FontWeight.w500),
                              // ),
                              SizedBox(height: 20),
                              Visibility(
                                visible: _select_visibility,
                                child: Container(
                                      height: 160,
                                      // width: MediaQuery.of(context).size.width,
                                      child:Center(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          //itemExtent: 150,
                                          itemCount: select_image_list.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                                width: 160.0,
                                                child: Card(
                                                  child: Image.network('http://localhost:8000/DATA/images/${select_image_list[index]}'),
                                                  )
                                                );
                                           },
                                   
                                        )
                                        )
                                       )
                                      ),
                                   
                                SizedBox(height: 48),
                                ButtonWidget(
                                  text: 'Convert',
                                  icon: Icons.published_with_changes_rounded,
                                  onClicked: getMosaic,
                                ),
                                SizedBox(height: 20),
                                Visibility(
                                    visible: _result_visibility,
                                    child: SizedBox(
                                      height: 300,
                                      child: ChewieListItem(
                                        videoPlayerController:
                                            VideoPlayerController.asset(
                                          // 'assets/output.mp4'
                                          'http://localhost:8000/DATA/outputs/$video_name',
                                        ),
                                        looping: true,
                                      ),
                                )),
                             ],
                            ))
                    ),
                  ),]
                ),
              ),
        
        );

        

  }

  void removeItem(int index) {
    final removedItem = items[index];
    items.removeAt(index);

    listKey.currentState!.removeItem(
      index,
      (context, animation) => ListItemWidget(
        item: removedItem, 
        animation: animation, 
        onClicked: (){},
        )
      );
  }

  Future<void> insertItem() async {

    var select_image_path = '';

    // 이미지 하나 선택
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      image_name = result.files.single.name;
      var uploadfile = result.files.single.bytes;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: image_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://localhost:8000/upload_image', data: formData);

      if (response.statusCode == 200) {
        select_image_path = response.data['imgUrl'];
        print(response.data['imgUrl']);
        // _changed(true, 'select');
      }
      
    }
      print("잉");
      var dio2 = Dio();
      final response2 = 
          await dio2.get('http://localhost:8000/given_image');
      
      print(response2.statusCode);
      if (response2.statusCode == 200) {
        print("와");
        given_img_list = response2.data['imgList'];
        print(given_img_list);
      }
    final newIndex = 0; // listItems.length;
    final newItem = ListItem(imageName: image_name, urlImage: select_image_path, selectIndex: 0);
    
    items.insert(newIndex, newItem);
    listKey.currentState!.insertItem(
      newIndex,
    );
  }

  Future uploadVideo() async {
    _changed(false, 'upload');

    // 비디오 하나 선택
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      video_name = result.files.single.name;
      var uploadfile = result.files.single.bytes;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: video_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://localhost:8000/upload_video', data: formData);

      if (response.statusCode == 200) {
        print(response.data['outputUrl']);
        _changed(true, 'upload');
      }

    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }

  Future selectImage() async {
    _changed(false, 'select');

    // 이미지 하나 선택
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      image_name = result.files.single.name;
      var uploadfile = result.files.single.bytes;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: image_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://localhost:8000/upload_image', data: formData);

      if (response.statusCode == 200) {
        print(response.data['imgUrl']);
        _changed(true, 'select');
      }

    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }

  Future selectGivenImage() async {
      var dio = Dio();
      // 업로드 요청
      final response =
          await dio.post('http://localhost:8000/select_given_image/' + given_img_list[_current_img]);
      if (response.statusCode == 200) {}
  }

  Future selectImages() async {
    _changed(false, 'select');

    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      select_image_list = List.generate(
        result.files.length,
        ((index) => result.files.elementAt(index).name));
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': List.generate(
            result.files.length,
            ((index) => MultipartFile.fromBytes(
                result.files.elementAt(index).bytes!,
                filename: result.files.elementAt(index).name)))
      });

      final response =
          await dio.post('http://localhost:8000/upload_images', data: formData);

      if (response.statusCode == 200) {
        print(select_image_list);
        _changed(true, 'select');
      }

    }
  }


  Future selectMode2() async {
    _changed(false, 'mode1');
    _changed(false, 'select');
    _changed(false, 'result');

    var dio = Dio();
    final response = 
         await dio.get('http://localhost:8000/given_image');
    

    if (response.statusCode == 200) {
      given_img_list = response.data['imgList'];
      print(given_img_list);
    }


    _changed(true, 'mode2');
  }


  Future multiSwapping() async {
    _changed(false, 'result');
    var dio = Dio();
    final response =
        await dio.post('http://localhost:8000/multi_swapping',
        // onSendProgress: (count, total) {
        //    var progress = count / total;
        //    print('progress: $progress ($count/$total)');
        //   }
        );

    if (response.statusCode == 200) {
        print(response.data['outputUrl']);
        _changed(true, 'result');
      }
  }

  Future specificSwapping() async {
    _changed(false, 'result');

    var dio = Dio();
    var formData = {
      'src_images': List.generate(
          items.length,
          ((index) => items[index].imageName.toString())),
      'dst_images': List.generate(
          items.length, 
          ((index) => given_img_list[items[index].getValue].toString()))
    };


    final response =
        await dio.post('http://localhost:8000/get_specific_swapping', data: formData, 
        );

    if (response.statusCode == 200) {
        // print(response.data['outputUrl']);
        _changed(true, 'result');
      }
  }

  

  Future selectMode1() async {
    _changed(false, 'mode2');
    _changed(false, 'select');
    _changed(false, 'result');
    _changed(true, 'mode1');
  }

  Future getMosaic() async {
    _changed(false, 'result');
    var dio = Dio();
    final response =
        await dio.post('http://localhost:8000/get_mosaic');

    if (response.statusCode == 200) {
        print(response.data['outputUrl']);
        _changed(true, 'result');
      }
  }

}



