import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/widget/button_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app/chewie_list_item.dart';

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

class _MainPageState extends State<MainPage> {
  // File? file;
  var video_name = '';
  var image_name = '';
  var image_file;
  bool _upload_visibility = false;
  bool _select_visibility = false;
  bool _result_visibility = false;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoName = video_name != '' ? video_name : 'No File Selected';
    final imageName = image_name != '' ? image_name : 'No File Selected';
    final imageBytes = image_file ?? Uint8List.fromList([0]);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                "logo.png",
                height: 99,
              ),
              Text(MyApp.title),
            ],
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                    text: 'Upload Video',
                    icon: Icons.cloud_upload_outlined,
                    onClicked: uploadFile,
                  ),
                  SizedBox(height: 8),
                  Text(
                    videoName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                      visible: _upload_visibility,
                      child: SizedBox(
                        height: 300,
                        child: ChewieListItem(
                          videoPlayerController: VideoPlayerController.asset(
                            // 'assets/output.mp4'
                            'http://localhost:8000/videos/$videoName',
                          ),
                          looping: true,
                        ),
                      )),
                  SizedBox(height: 48),
                  ButtonWidget(
                    text: 'Select Image',
                    icon: Icons.mms_outlined,
                    onClicked: selectImageSwapping,
                  ),
                  SizedBox(height: 8),
                  Text(
                    imageName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                      visible: _select_visibility,
                      child: SizedBox(
                        height: 250,
                        child: Image.memory(imageBytes),
                      )),
                  SizedBox(height: 48),
                  ButtonWidget(
                    text: 'Download Result',
                    icon: Icons.download_for_offline_outlined,
                    onClicked: selectImageSwapping,
                  ),
                  SizedBox(height: 20),
                  Visibility(
                      visible: _result_visibility,
                      child: SizedBox(
                        height: 300,
                        child: ChewieListItem(
                          videoPlayerController: VideoPlayerController.asset(
                            // 'assets/output.mp4'
                            'http://localhost:8000/videos/$videoName',
                          ),
                          looping: true,
                        ),
                      )),
                  // task != null ? buildUploadStatus(task!) : Container(),
                ],
              ),
            ),
          ),
        ));
  }

  Future uploadFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      // File file = result.files.single;
      video_name = result.files.single.name;
      var uploadfile = result.files.single.bytes;
      // print(uploadfile.toString());

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: video_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://localhost:8000/upload-videos', data: formData);

      _changed(true, 'upload');

      print('http://localhost:8000/videos/' + video_name.toString());

      // print(response.headers);
      // print(response.data['fileUrls']);
    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }

  Future selectImageSwapping() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      // File file = result.files.single;
      // var image_path = result.files.single.path;
      // print(image_path);
      image_name = result.files.single.name;
      image_file = result.files.single.bytes;
      // print(uploadfile.toString());

      _changed(true, 'select');

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(image_file!, filename: image_name)
      });

      // 업로드 요청
      final response =
          await dio.post('http://localhost:8000/swapping', data: formData);

      _changed(true, 'result');

      // print(response.headers);
      // print(response.data['fileUrls']);
    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }
}
