import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/widget/button_widget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app/chewie_list_item.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
  // runApp(VideoPlayerApp());
}

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    // VideoPlayerController를 저장하기 위한 변수를 만듭니다. VideoPlayerController는
    // asset, 파일, 인터넷 등의 영상들을 제어하기 위해 다양한 생성자를 제공합니다.
    _controller = VideoPlayerController.network(
      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      // './assets/output.mp4',
      'http://localhost:8000/images/' +
          '2022081921545664e1102a837cc425920ddb4609f4d160.mp4',
    );

    // 컨트롤러를 초기화하고 추후 사용하기 위해 Future를 변수에 할당합니다.
    _initializeVideoPlayerFuture = _controller!.initialize();

    // 비디오를 반복 재생하기 위해 컨트롤러를 사용합니다.
    _controller?.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController를 dispose 시키세요.
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Butterfly Video'),
      ),
      // VideoPlayerController가 초기화를 진행하는 동안 로딩 스피너를 보여주기 위해
      // FutureBuilder를 사용합니다.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 만약 VideoPlayerController 초기화가 끝나면, 제공된 데이터를 사용하여
            // VideoPlayer의 종횡비를 제한하세요.
            return AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              // 영상을 보여주기 위해 VideoPlayer 위젯을 사용합니다.
              child: VideoPlayer(_controller!),
            );
          } else {
            // 만약 VideoPlayerController가 여전히 초기화 중이라면,
            // 로딩 스피너를 보여줍니다.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 재생/일시 중지 기능을 `setState` 호출로 감쌉니다. 이렇게 함으로써 올바른 아이콘이
          // 보여집니다.
          setState(() {
            // 영상이 재생 중이라면, 일시 중지 시킵니다.
            if (_controller!.value.isPlaying) {
              _controller!.pause();
            } else {
              // 만약 영상이 일시 중지 상태였다면, 재생합니다.
              _controller!.play();
            }
          });
        },
        // 플레이어의 상태에 따라 올바른 아이콘을 보여줍니다.
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // 이 마지막 콤마는 build 메서드에 자동 서식이 잘 적용될 수 있도록 도와줍니다.
    );
  }
}

class MyApp extends StatelessWidget {
  static final String title = 'Upload Files';

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
  // UploadTask? task;
  File? file;
  bool _upload_visibility = false;
  bool _result_visibility = false;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "upload") {
        _upload_visibility = visibility;
      }
      if (field == "result") {
        _result_visibility = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
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
                    text: 'Upload File',
                    icon: Icons.attach_file,
                    onClicked: uploadFile,
                  ),
                  SizedBox(height: 8),
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 48),
                  Visibility(
                    visible: _upload_visibility,
                    child: ChewieListItem(
                      videoPlayerController: VideoPlayerController.asset(
                          'assets/output.mp4'
                          // 'http://localhost:8000/images/' +
                          //     '2022082117151290fd8c966028d34459a009e12686c755.mp4',
                          ),
                      looping: true,
                    ),
                  ),
                  SizedBox(height: 48),
                  ButtonWidget(
                    text: 'Get File',
                    icon: Icons.cloud_upload_outlined,
                    onClicked: getFile,
                  ),
                  SizedBox(height: 20),
                  // task != null ? buildUploadStatus(task!) : Container(),
                ],
              ),
            ),
          ),
        ));
  }

  Future uploadFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    // FilePickerResult? result =
    //    await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      var filename = result.files.single.name;
      var uploadfile = result.files.single.bytes;
      // print(uploadfile.toString());

      // final savePath = './assets/input.mp4';
      // File file = await File(savePath);
      // // var raf = file.openWrite(mode: FileMode.write);
      // var raf = file.openSync(mode: FileMode.write);
      // // raf.addStream(response.data);
      // raf.writeFromSync(uploadfile!);
      // await raf.close;

      // 파일 경로를 통해 formData 생성
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(uploadfile!, filename: filename)
      });

      // 업로드 요청
      final response =
          await dio.post('http://localhost:8000/upload-images', data: formData);

      _changed(true, 'upload');

      print(response.headers);
      print(response.data['fileUrls']);
    } else {
      // 아무런 파일도 선택되지 않음.
    }
  }

  Future uploadMultiFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    // FilePickerResult? result =
    //    await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': List.generate(
            result.files.length,
            ((index) => MultipartFile.fromBytes(
                result.files.elementAt(index).bytes!,
                filename: result.files.elementAt(index).name)))
      });

      final response =
          await dio.post('http://localhost:8000/upload-images', data: formData);

      // for (PlatformFile file in result.files) {
      //   var filename = file.name;
      //   var uploadfile = file.bytes;
      //   // print(uploadfile.toString());

      //   // 파일 경로를 통해 formData 생성
      //   var dio = Dio();
      //   var formData = FormData.fromMap({
      //     'in_files': MultipartFile.fromBytes(uploadfile!, filename: filename)
      //   });

      //   // 업로드 요청
      //   final response = await dio.post('http://localhost:8000/upload-images',
      //       data: formData);
      // }
    }
  }

  Future getFile() async {
    Response response;
    var dio = Dio();
    // 업로드 요청
    response = await dio.get(
        'http://localhost:8000/images/' +
            '2022081921545664e1102a837cc425920ddb4609f4d160.mp4',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ));

    if (response.statusCode == 200) {
      print(response.headers);
      // print(response.data);
      final savePath = './assets/output.mp4';
      File file = await File(savePath);
      // var raf = file.openWrite(mode: FileMode.write);
      var raf = file.openSync(mode: FileMode.write);
      // raf.addStream(response.data);
      raf.writeFromSync(response.data);
      await raf.close;
      // raf.write
      // file = jsonDecode(response.data) as File;
      // VideoPlayerController
      // response.Stream.
    }
  }
}
