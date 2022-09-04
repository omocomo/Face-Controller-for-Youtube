import 'package:dio/dio.dart';
import 'package:face_controller_for_youtube/widgets/carousel.dart';
import 'package:face_controller_for_youtube/widgets/heading.dart';
import 'package:face_controller_for_youtube/widgets/responsive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';




// 얼굴바꾸기

class ChangeContents extends StatefulWidget {
  @override
  _ChangeContentsState createState() => _ChangeContentsState();
}

class _ChangeContentsState extends State<ChangeContents> {
  var server = 'localhost';
  var video_name = 'No File Selected';
  var image_name = 'No File Selected';

  Future<void> insertItem() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      image_name = result.files.single.name;
      var upload_file = result.files.single.bytes;

      var dio = Dio();
      var formData = FormData.fromMap({
        'in_files': MultipartFile.fromBytes(upload_file!, filename: image_name)
      });

      final response = await dio.post('http://$server:8000/upload_image', data: formData);

      if (response.statusCode == 200) {
        // select_image_path = response.data['imgUrl'];
      }
    }

    var dio2 = Dio();
    final response2 = await dio2.get('http://$server:8000/given_image');

    if (response2.statusCode == 200) {
      // given_img_list = response2.data['imgList'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Heading(title: "모든 얼굴 바꾸기", subtitle: "모든 인물의 얼굴을 바꿉니다", screenSize: screenSize),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "동영상 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Container(
            width: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5
                : screenSize.width / 1.5,
            height: ResponsiveWidget.isLargeScreen(context)
                ? 1200 / 1.5 / 16 * 9
                : screenSize.width / 1.5 / 16 * 9,
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Visibility(
          visible: true,
          child: Text(
            "어떤 얼굴로 바꾸실 건가요?"
          ),
        ),
        SizedBox(
          height: 10,
        ),
        DestinationCarousel(),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "CONVERT",
          ),
        ),
        SizedBox(
          height: 100,
        ),

        Heading(title: "특정 얼굴 바꾸기", subtitle: "특정 인물의 얼굴을 바꿉니다", screenSize: screenSize),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "동영상 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Container(
              width: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5
                  : screenSize.width / 1.5,
              height: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5 / 16 * 9
                  : screenSize.width / 1.5 / 16 * 9,
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
            ),
          ),
        SizedBox(
          height: 40,
        ),
        Visibility(
          visible: true,
          child: Text(
            "어떤 얼굴을 바꾸실 건가요?"
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "사진 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5 / 2
                  : screenSize.width / 1.5 / 2,
              height: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5 / 2 / 1.5
                  : screenSize.width / 1.5 / 2 / 1.5,
              decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
            ),
            DestinationCarousel(),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.remove_circle,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "CONVERT",
          ),
        ),

        SizedBox(height: screenSize.height / 10),
      ]
    );
  }
}




// 모자이크

class MosaicContents extends StatefulWidget {
  @override
  _MosaicContentsState createState() => _MosaicContentsState();
}

class _MosaicContentsState extends State<MosaicContents> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Heading(title: "얼굴 모자이크하기", subtitle: "특정 인물을 제외한 나머지 얼굴을 모자이크합니다", screenSize: screenSize),
        SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "동영상 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
            child: Container(
              width: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5
                  : screenSize.width / 1.5,
              height: ResponsiveWidget.isLargeScreen(context)
                  ? 1200 / 1.5 / 16 * 9
                  : screenSize.width / 1.5 / 16 * 9,
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
            ),
          ),
        SizedBox(
          height: 40,
        ),
        Visibility(
          visible: true,
          child: Text(
            "어떤 얼굴을 모자이크하지 않을 건가요?"
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "사진 업로드",
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveWidget.isLargeScreen(context)
                    ? 1200 / 1.5 / 2
                    : screenSize.width / 1.5 / 2,
                height: ResponsiveWidget.isLargeScreen(context)
                    ? 1200 / 1.5 / 2 / 1.5
                    : screenSize.width / 1.5 / 2 / 1.5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.remove_circle,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "CONVERT",
          ),
        ),

        SizedBox(height: screenSize.height / 10),
      ]
    );
  }
}